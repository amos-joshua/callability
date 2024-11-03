package net.swiftllama.callability

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.AudioManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        private const val TAG = "CALLABILITY_NATIVE"
    }

    private val methodChannelId = "net.swiftllama.callquery/notifications"
    private lateinit var methodChannel: MethodChannel
    private val intentHelper = IntentHelper()
    private val resourceHelper = ResourceHelper()
    private val notificationHelper = NotificationHelper()
    private val permissionsHelper = PermissionsHelper()
    private val ringTypeHelper = RingTypeHelper()

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        intentHelper.processIntent(this, methodChannel, intent)
    }

    @RequiresApi(Build.VERSION_CODES.S)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelId)
        methodChannel.setMethodCallHandler {
                call, result ->
            when(call.method) {
                "requestAccessNotificationPolicyPermissions" -> permissionsHelper.requestAccessNotificationPolicyPermissions(this)
                "showCallNotification" -> showCallNotification(call.arguments as List<*>)
                "showMissedCallNotification" -> showMissedCallNotification(call.arguments as List<*>)
                "cancelCallNotification" -> cancelCallNotification(call.arguments as List<*>)
                "hasAccessNotificationPolicyPermissions" -> {
                    val status = permissionsHelper.hasAccessNotificationPolicyPermissions(this)
                    result.success(status)
                }
                else -> result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun cancelCallNotification(argumentList: List<*>) {
        try {
            val arguments = DartNotificationArguments.from(argumentList)
            ringTypeHelper.restorePreviousRingerMode(this)
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(NotificationHelper.incomingNotificationTag(arguments.callUuid), NotificationHelper.INCOMING_NOTIFICATION_ID)
        }
        catch (exc: Exception) {
            Log.e(TAG, "ERROR cancelling call notification for $argumentList", exc)
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun showMissedCallNotification(argumentList: List<*>) {
        try {
            val arguments = DartNotificationArguments.from(argumentList)
            val channel = notificationHelper.channel(this, arguments.ringType, true)
            val contentIntent = intentHelper.pendingIntent(this, 1, Intent(this, MainActivity::class.java))

            val builder = Notification.Builder(context, channel.id)
                .setContentIntent(contentIntent)
                .setAutoCancel(true)
                .setColor(arguments.urgencyColor())
                .setSmallIcon(resourceHelper.missedCallIcon(context, arguments.urgency))
                .setContentTitle("Missed: ${arguments.contactName}")
                .setContentText(arguments.urgencyAndSubject())

            ringTypeHelper.restorePreviousRingerMode(this)

            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(NotificationHelper.incomingNotificationTag(arguments.callUuid), NotificationHelper.INCOMING_NOTIFICATION_ID)
            notificationManager.notify(NotificationHelper.missedNotificationTag(arguments.callUuid), NotificationHelper.MISSED_NOTIFICATION_ID, builder.build())
        }
        catch (exc: Exception) {
            Log.e(TAG, "ERROR showing call notification for $argumentList", exc)
        }
    }

    @RequiresApi(Build.VERSION_CODES.S)
    private fun showCallNotification(argumentList: List<*>) {
        try {
            val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
            audioManager.mode = AudioManager.MODE_NORMAL;

            val arguments = DartNotificationArguments.from(argumentList)
            val channel = notificationHelper.channel(this, arguments.ringType, false)

            if ((arguments.urgency >= 1) && (arguments.ringType >= 1)) {
                ringTypeHelper.setRingMode(this, arguments.ringerMode())
            }

            val incomingCaller = Person.Builder()
                .setName(arguments.contactName)
                .setImportant(true)
                .build()

            val contentIntent = intentHelper.pendingIntent(this, 1, Intent(this, MainActivity::class.java))
            val declinePendingIntent = intentHelper.pendingIntent(
                this,
                2,
                intentHelper.actionIntent(this, arguments.callUuid, "decline"),
            )
            val answerPendingIntent = intentHelper.pendingIntent(
                this,
                3,
                intentHelper.actionIntent(this, arguments.callUuid, "accept")
            )

            val appIcon = resourceHelper.appIcon(this)

            val builder = Notification.Builder(context, channel.id)
                .setContentIntent(contentIntent)
                .setAutoCancel(true)
                .setColor(Color.rgb(0,196, 0))
                .setSmallIcon(appIcon)
                .setLargeIcon(resourceHelper.callIcon(this, arguments.urgency))
                .setContentTitle(arguments.contactName)
                .setContentText(arguments.urgencyAndSubject())
                .setFullScreenIntent(contentIntent, true)
                .setCategory(Notification.CATEGORY_CALL)
                .setStyle(Notification.CallStyle.forIncomingCall(
                    incomingCaller,
                    declinePendingIntent,
                    answerPendingIntent
                    )
                )
                .setColorized(true)
                .setFlag(Notification.FLAG_INSISTENT, true)

            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NotificationHelper.incomingNotificationTag(arguments.callUuid), NotificationHelper.INCOMING_NOTIFICATION_ID, builder.build())
        }
        catch (exc: Exception) {
            Log.e(TAG, "ERROR showing call notification for $argumentList", exc)
        }
    }

}
