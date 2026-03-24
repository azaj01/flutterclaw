#include <jni.h>
#include <pty.h>       // openpty()
#include <sys/ioctl.h> // TIOCSWINSZ
#include <termios.h>   // struct winsize
#include <unistd.h>    // read(), write(), close()
#include <fcntl.h>
#include <cerrno>
#include <android/log.h>

#define LOG_TAG "PtyHelper"

extern "C" {

/**
 * Allocates a PTY master/slave pair.
 * Returns [masterFd, slaveFd] or null on failure.
 *
 * The slave fd should be passed as stdin/stdout/stderr to the subprocess
 * (via /proc/self/fd/<slaveFd>). The master fd is used to read/write the process.
 */
JNIEXPORT jintArray JNICALL
Java_ai_flutterclaw_flutterclaw_PtyHelper_openPty(
        JNIEnv *env, jclass, jint cols, jint rows) {
    struct winsize ws = {};
    ws.ws_col = (unsigned short) cols;
    ws.ws_row = (unsigned short) rows;

    int master = -1, slave = -1;
    if (openpty(&master, &slave, nullptr, nullptr, &ws) != 0) {
        __android_log_print(ANDROID_LOG_ERROR, LOG_TAG,
                            "openpty() failed: errno=%d", errno);
        return nullptr;
    }

    jintArray result = env->NewIntArray(2);
    if (!result) {
        close(master);
        close(slave);
        return nullptr;
    }
    jint fds[2] = {master, slave};
    env->SetIntArrayRegion(result, 0, 2, fds);
    return result;
}

/**
 * Blocking read from a PTY master fd.
 * Returns bytes read (>0), 0 on timeout, or -1 on error/EIO (slave closed).
 */
JNIEXPORT jint JNICALL
Java_ai_flutterclaw_flutterclaw_PtyHelper_readPty(
        JNIEnv *env, jclass, jint fd, jbyteArray buf) {
    jsize len = env->GetArrayLength(buf);
    jbyte *bytes = env->GetByteArrayElements(buf, nullptr);
    ssize_t n = read(fd, bytes, (size_t) len);
    env->ReleaseByteArrayElements(buf, bytes, 0);
    return (jint) n;
}

/**
 * Write data to a PTY master fd (sends input to the subprocess).
 * Returns bytes written or -1 on error.
 */
JNIEXPORT jint JNICALL
Java_ai_flutterclaw_flutterclaw_PtyHelper_writePty(
        JNIEnv *env, jclass, jint fd, jbyteArray buf, jint len) {
    jbyte *bytes = env->GetByteArrayElements(buf, nullptr);
    ssize_t n = write(fd, bytes, (size_t) len);
    env->ReleaseByteArrayElements(buf, bytes, JNI_ABORT);
    return (jint) n;
}

/**
 * Resize the terminal window. Call when the UI layout changes.
 */
JNIEXPORT void JNICALL
Java_ai_flutterclaw_flutterclaw_PtyHelper_resize(
        JNIEnv *, jclass, jint masterFd, jint cols, jint rows) {
    struct winsize ws = {};
    ws.ws_col = (unsigned short) cols;
    ws.ws_row = (unsigned short) rows;
    ioctl(masterFd, TIOCSWINSZ, &ws);
}

/**
 * Close a native file descriptor.
 */
JNIEXPORT void JNICALL
Java_ai_flutterclaw_flutterclaw_PtyHelper_closeFd(
        JNIEnv *, jclass, jint fd) {
    if (fd >= 0) close(fd);
}

} // extern "C"
