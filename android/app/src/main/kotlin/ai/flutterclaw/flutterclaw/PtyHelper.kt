package ai.flutterclaw.flutterclaw

/**
 * JNI wrapper for native PTY (pseudo-terminal) allocation via openpty().
 *
 * Usage:
 *   val fds = PtyHelper.openPty(cols = 220, rows = 50) ?: return // [masterFd, slaveFd]
 *   // Redirect subprocess stdin/stdout/stderr to File("/proc/self/fd/${fds[1]}")
 *   // Read subprocess output from fds[0] via PtyHelper.readPty()
 *   // Close both fds when done via PtyHelper.closeFd()
 */
class PtyHelper private constructor() {
    companion object {
        init {
            System.loadLibrary("ptyhelper")
        }

        /**
         * Allocates a pseudo-terminal pair.
         * @param cols Terminal width in character columns (affects TUI layout).
         * @param rows Terminal height in rows.
         * @return IntArray of [masterFd, slaveFd], or null on failure.
         */
        @JvmStatic external fun openPty(cols: Int, rows: Int): IntArray?

        /**
         * Blocking read from a PTY master fd.
         * Returns bytes read (> 0), or -1 when the slave end closes (process exited).
         */
        @JvmStatic external fun readPty(fd: Int, buf: ByteArray): Int

        /**
         * Write data to a PTY master fd (sends keyboard input to the subprocess).
         * Returns bytes written, or -1 on error.
         */
        @JvmStatic external fun writePty(fd: Int, buf: ByteArray, len: Int): Int

        /**
         * Resize the terminal window. Should be called when the UI changes size.
         */
        @JvmStatic external fun resize(masterFd: Int, cols: Int, rows: Int)

        /**
         * Close a native file descriptor.
         */
        @JvmStatic external fun closeFd(fd: Int)
    }
}
