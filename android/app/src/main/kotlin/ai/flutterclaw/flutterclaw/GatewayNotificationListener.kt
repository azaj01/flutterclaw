package ai.flutterclaw.flutterclaw

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import com.pravera.flutter_foreground_task.FlutterForegroundTaskLifecycleListener
import com.pravera.flutter_foreground_task.FlutterForegroundTaskStarter
import com.pravera.flutter_foreground_task.PreferencesKey as PrefsKey
import com.pravera.flutter_foreground_task.models.ForegroundServiceAction
import com.pravera.flutter_foreground_task.models.ForegroundServiceStatus
import com.pravera.flutter_foreground_task.models.NotificationContent
import com.pravera.flutter_foreground_task.service.ForegroundService
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Listener for the foreground task's Flutter engine. Registers a method channel
 * so the task (running in a separate engine) can request notification updates.
 * On Android 15, updateService() from the task's engine does not apply; updating
 * via SharedPreferences + API_UPDATE from the service process works.
 */
class GatewayNotificationListener(private val context: Context) : FlutterForegroundTaskLifecycleListener {

    override fun onEngineCreate(flutterEngine: FlutterEngine?) {
        if (flutterEngine == null) return
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "ai.flutterclaw/notification_update"
        )
        channel.setMethodCallHandler { call, result ->
            if (call.method == "update") {
                @Suppress("UNCHECKED_CAST")
                val args = call.arguments as? Map<String, Any?>
                val title = args?.get("notificationContentTitle") as? String ?: ""
                val text = args?.get("notificationContentText") as? String ?: ""
                val map = mapOf(
                    PrefsKey.NOTIFICATION_CONTENT_TITLE to title,
                    PrefsKey.NOTIFICATION_CONTENT_TEXT to text,
                )
                NotificationContent.updateData(context.applicationContext, map)
                ForegroundServiceStatus.setData(context.applicationContext, ForegroundServiceAction.API_UPDATE)
                val intent = Intent(context.applicationContext, ForegroundService::class.java)
                ContextCompat.startForegroundService(context.applicationContext, intent)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onTaskStart(starter: FlutterForegroundTaskStarter) {}
    override fun onTaskRepeatEvent() {}
    override fun onTaskDestroy() {}
    override fun onEngineWillDestroy() {}
}
