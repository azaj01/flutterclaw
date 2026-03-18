# iOS Sandbox Networking — Implementation Plan

Give the Alpine 3.21 RISC-V guest inside TinyEMU/WAMR full outbound internet
access so that `apk add`, `curl`, `pip install`, etc. work on iOS just as they
do on Android.

---

## Background

The current sandbox has no internet.  The guest runs inside a TinyEMU RISC-V
emulator compiled to WASM.  The emulator has a virtio-net device but it is not
connected to any host network stack — packets sent from Alpine simply disappear.

The mechanism that _can_ fix this is **container2wasm's `--net=socket` mode**:

```
Alpine guest
  └─ Linux virtio-net driver
       └─ TinyEMU virtio-net device  ←→  raw Ethernet frames over WASI socket fd=3
                                              │
                                    ┌─────────▼──────────┐
                                    │  host network stack │  (gvisor-tap-vsock)
                                    │  192.168.127.1 GW   │
                                    │  → NAT → internet   │
                                    └────────────────────┘
```

The WASM binary sends and receives raw Ethernet frames over a WASI socket
(fd=3).  A host-side user-space TCP/IP stack (gvisor-tap-vsock) receives those
frames, routes TCP/UDP connections, and forwards them to the real internet.

On macOS/Linux this is the `c2w-net` CLI binary.  On iOS we need to embed an
equivalent stack inside the app.

---

## How c2w networking works (technical)

1. **Build-time**: `c2w --net=socket --target-arch riscv64 IMAGE out.wasm`
   configures TinyEMU to expose its virtio-net device over WASI fd=3 instead
   of being a no-op.

2. **Run-time WASM side**: on startup the WASM calls WASI `sock_open` /
   `sock_connect` to connect fd=3 to a TCP endpoint provided by the host.
   It then pumps raw Ethernet frames (QEMU socket forwarding protocol: 4-byte
   big-endian length prefix + frame payload) through that connection.

3. **Run-time host side** (`c2w-net` / gvisor-tap-vsock):
   - Virtual subnet `192.168.127.0/24`; gateway at `192.168.127.1`; guest at
     `192.168.127.3`.
   - Accepts the TCP connection from the WASM.
   - Implements a user-space TCP/IP stack: ARP, IP, TCP, UDP, DNS.
   - Routes outbound connections from the guest to the real internet via the
     host OS's socket API (POSIX `connect`, `send`, `recv`).

4. **WAMR requirement**: must be built with socket extensions
   (`-DWAMR_BUILD_LIBC_WASI=1` already on + socket allowlist via
   `wasm_runtime_set_wasi_addr_pool`).  A pre-bound TCP listener fd must be
   created by the host and passed to the WASM as the socket fd before
   `wasm_runtime_instantiate`.

---

## Implementation phases

### Phase 0 — Prototype on macOS with wasmtime (≈3 days)

Goal: confirm the full pipeline works before writing any iOS code.

```bash
# Install c2w-net
brew install ktock/tap/container2wasm   # installs both c2w and c2w-net

# Rebuild the WASM with network support
c2w --net=socket --target-arch riscv64 \
    flutterclaw-ios-sandbox:build \
    scripts/ios-sandbox/out/alpine-ios-sandbox-net.wasm

# Run with networking
c2w-net --invoke scripts/ios-sandbox/out/alpine-ios-sandbox-net.wasm \
    --net=socket -- /bin/sh
# Inside: apk update && apk add curl && curl https://example.com
```

If `apk add` succeeds, the mechanism is confirmed.  Record:
- The exact fd number used (`listenfd=<N>`, determined by how many preopens
  WAMR opens before the socket).
- Whether WAMR's WASI socket extension is required or if fd=3 is pre-opened
  as a regular file descriptor.

**Deliverable**: working `alpine-ios-sandbox-net.wasm` + notes on fd numbering.

---

### Phase 1 — iOS network stack via gomobile (≈2 weeks)

The host-side network stack is the hardest part.  `gvisor-tap-vsock` is a
production-quality Go library that implements exactly what we need.  We embed
it in the iOS app using **gomobile**.

#### 1a. Create a Go bridge package

```
ios/c2w-net-ios/
  go.mod
  network.go      ← thin wrapper around gvisor-tap-vsock
```

`network.go` exposes two functions via gomobile:
- `StartNetworkStack(socketPath string) error` — starts the virtual network,
  listens for the WASM to connect via a Unix socket.
- `StopNetworkStack()`

```go
package c2wnet

import (
    gvntypes "github.com/containers/gvisor-tap-vsock/pkg/types"
    gvnvirtualnetwork "github.com/containers/gvisor-tap-vsock/pkg/virtualnetwork"
)

const (
    gatewayIP = "192.168.127.1"
    vmIP      = "192.168.127.3"
)

func StartNetworkStack(unixPath string) error {
    config := gvntypes.Configuration{
        GatewayIP:  gatewayIP,
        GatewayMAC: "5a:94:ef:e4:0c:dd",
        MTU:        1500,
    }
    vn, err := gvnvirtualnetwork.New(&config)
    if err != nil { return err }
    // accept connections from WASM over the unix socket, pump frames
    go acceptLoop(vn, unixPath)
    return nil
}
```

#### 1b. Build the iOS framework

```bash
# Install gomobile
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init

# Build for iOS device + simulator
cd ios/c2w-net-ios
gomobile bind \
    -target ios,iossimulator \
    -o ios/C2WNet.xcframework \
    .
```

This produces `ios/C2WNet.xcframework` which is added to the Xcode project
exactly like `wamr.xcframework`.

**Alternative if gomobile proves difficult**: rewrite the QEMU frame-pump
loop in Swift (~300 lines) using `Network.framework` for outbound connections,
skipping a full TCP/IP stack in favour of a simpler TCP-proxy approach (see
Appendix A).

---

### Phase 2 — WAMR socket support (≈3 days)

WAMR needs to expose the host-side socket fd to the WASM as WASI fd=3 (or
whatever fd number `listenfd=` is configured to).

#### 2a. WAMR build flags (`scripts/build-wamr-ios.sh`)

Add to `WAMR_CMAKE_FLAGS`:

```bash
-DWAMR_BUILD_SOCKET_INET=1      # Berkeley socket extensions
-DWAMR_BUILD_THREAD_MGR=0       # keep off (no JIT needed)
```

#### 2b. Socket fd injection in `WasmSandboxHandler.swift`

Before calling `wasm_runtime_set_wasi_args_ex`, create a Unix socket pair
(or TCP loopback listener), start the Go network stack on one end, and pass
the other end's fd as an additional preopen.  The exact API:

```swift
// Create a connected socket pair for the network channel.
var netPair = [Int32](repeating: 0, count: 2)
socketpair(AF_UNIX, SOCK_STREAM, 0, &netPair)

// Start the Go network stack on netPair[0].
C2WNet.startNetworkStack(netPair[0])

// Pass netPair[1] to WAMR alongside the other pipe fds.
// The fd number at WASI level must match --net=socket=listenfd=N in the WASM.
wasm_runtime_set_wasi_args_ex(
    module,
    ...,
    Int64(inPipe[0]),    // stdin
    Int64(outPipe[1]),   // stdout
    Int64(errPipe[1]),   // stderr
    // netPair[1] must land on fd=3 inside WASI.
    // WAMR assigns preopens in order after 0/1/2, so the first extra fd
    // passed here gets WASI fd=3.  Verify with Phase 0 prototype.
)

// After wasm_runtime_deinstantiate:
C2WNet.stopNetworkStack()
close(netPair[0])
close(netPair[1])
```

> **Note**: the exact mechanism for passing the socket fd to WAMR may differ
> from above depending on what `wasm_runtime_set_wasi_args_ex` supports for
> arbitrary fds.  If WAMR doesn't accept socket fds as preopens, an alternative
> is to `dup2(netPair[1], 3)` before instantiation (similar to how we
> originally tried dup2 for stdout — but this time fd=3 is unused).

---

### Phase 3 — WASM rebuild (≈1 day)

Update `scripts/ios-sandbox/build.sh` and `.github/workflows/build-ios-sandbox.yml`:

```bash
c2w \
    --net=socket \                   # ← new
    --target-arch riscv64 \
    "${IMAGE_TAG}" \
    "${RAW_WASM}"
```

Update `WasmSandboxHandler.swift`:
- New download URL and SHA256 for the `-net` variant of the image.
- `wasmVersion` bump (e.g. `3.21.0-2`).

Update `scripts/ios-sandbox/Dockerfile` to add packages useful with internet:
```dockerfile
RUN apk add --no-cache \
    python3 py3-pip git curl wget jq bash file \
    nodejs npm          # optional: useful when internet works
```

---

### Phase 4 — Integration & polish (≈1 week)

1. **fd numbering**: verify which WASI fd the WASM uses for the network socket
   (should be 3, but depends on how many dir preopens WAMR opens first).
   Adjust `listenfd=` in the WASM build if needed.

2. **DNS**: gvisor-tap-vsock provides a DNS resolver at the gateway IP.
   Configure Alpine's `/etc/resolv.conf` via the Dockerfile:
   ```dockerfile
   RUN echo "nameserver 192.168.127.1" > /etc/resolv.conf
   ```

3. **Timeout**: network operations can be slow; increase the default
   `timeout_ms` recommendation in `sandbox_tools.dart` for iOS.

4. **Thread safety**: the Go network stack goroutines and the WAMR GCD thread
   will run concurrently.  Verify no data races on the socket pair.

5. **Cleanup on timeout**: if `wasm_runtime_terminate()` is called, stop the
   network stack and close the socket pair cleanly.

6. **Update `sandbox_status`**: set `"network": true` on the result dict once
   the net WASM is in use.

7. **Update tool description** in `sandbox_tools.dart` to remove the "NO
   internet access" warnings.

---

## App Store compliance

| Concern | Status |
|---|---|
| Outbound TCP/UDP sockets | ✅ Allowed via Network.framework / POSIX |
| Raw/packet sockets | ❌ Not needed — gvisor-tap-vsock uses TCP for routing |
| `fork`/`exec` subprocess | ❌ Not needed — gomobile runs in-process |
| Background networking | Use `URLSession` background tasks if needed |
| ATS (App Transport Security) | gvisor routes directly via POSIX; not affected |

No special entitlements required.

---

## Effort estimate

| Phase | Effort |
|---|---|
| 0 — macOS prototype | 3 days |
| 1 — iOS gomobile network stack | 2 weeks |
| 2 — WAMR socket support | 3 days |
| 3 — WASM rebuild | 1 day |
| 4 — Integration & polish | 1 week |
| **Total** | **~5 weeks** |

Most of the risk is in Phase 1 (gomobile + gvisor-tap-vsock on iOS).  If
gomobile proves unworkable, fall back to the Swift reimplementation described
in Appendix A (~1 week extra).

---

## Appendix A — Simplified Swift network stack (fallback)

Instead of embedding gvisor-tap-vsock, implement only what `apk add` needs:
TCP proxy + DNS.  This covers ~95% of use cases without a full IP stack.

```
WASM → Ethernet frames → Swift frame parser
                              │
                    ┌─────────▼──────────────┐
                    │  SwiftNetProxy          │
                    │  - ARP responder        │
                    │  - TCP connection table │
                    │  - For each TCP conn:   │
                    │    NWConnection to real │
                    │    host:port via iOS    │
                    │  - DNS: forward to 8.8  │
                    └────────────────────────┘
```

Libraries: `Network.framework` (NWConnection, NWListener), Swift concurrency.
Estimated ~600 lines of Swift.  Does not support raw UDP (only DNS via
forwarding), ICMP (`ping`), or exotic protocols.  Sufficient for `apk add`,
`curl`, `wget`, `pip install`, `npm install`.

---

## Appendix B — Files to change

| File | Change |
|---|---|
| `scripts/build-wamr-ios.sh` | Add `-DWAMR_BUILD_SOCKET_INET=1` |
| `scripts/ios-sandbox/build.sh` | Add `--net=socket` to c2w call |
| `.github/workflows/build-ios-sandbox.yml` | Same |
| `scripts/ios-sandbox/Dockerfile` | Add `/etc/resolv.conf` DNS config |
| `ios/Runner/WasmSandboxHandler.swift` | Socket pair + C2WNet lifecycle |
| `ios/C2WNet.xcframework` | New — gomobile output (or Swift impl) |
| `ios/WAMR/wamr.xcframework` | Rebuild with socket support |
| `lib/tools/sandbox_tools.dart` | Remove "NO internet" warnings |
| `WasmSandboxHandler.wasmDownloadURL` | New image URL + SHA256 |
