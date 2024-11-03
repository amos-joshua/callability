package net.swiftllama.callability

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity.NOTIFICATION_SERVICE
import io.flutter.plugin.common.MethodChannel

class IntentHelper() {

    @RequiresApi(Build.VERSION_CODES.ECLAIR)
    fun processIntent(context: Context, methodChannel: MethodChannel, intent: Intent) {
        val callUuid = intent.getStringExtra("callUuid")
        val callAction = intent.getStringExtra("callAction")
        val notificationTag = intent.getStringExtra("notificationTag")
        val notificationId = intent.getIntExtra("notificationId", -1)

        if ((notificationTag != null) and (notificationId != -1)) {
            val notificationManager = context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.cancel(notificationTag, notificationId)
        }
        if ((callUuid != null) && (callAction != null)) {
            methodChannel.invokeMethod("callAction", listOf(callAction, callUuid))
        }
    }

    fun actionIntent(context: Context, callUuid: String, action: String) = Intent(context, MainActivity::class.java).apply {
        putExtra("callUuid", callUuid)
        putExtra("callAction", action)
        putExtra("notificationTag", NotificationHelper.incomingNotificationTag(callUuid))
        putExtra("notificationId", NotificationHelper.INCOMING_NOTIFICATION_ID)
        flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        data = Uri.parse("call://$callUuid/$action")
    }

    @RequiresApi(Build.VERSION_CODES.CUPCAKE)
    fun pendingIntent(context: Context, requestCode: Int, intent: Intent): PendingIntent = PendingIntent.getActivity(
        context,
        requestCode,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
    )

}