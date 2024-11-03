package net.swiftllama.callability

import android.app.*
import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.RingtoneManager
import android.os.Build
import androidx.annotation.RequiresApi

class NotificationHelper {
    companion object {
        const val TAG = "CALLABILITY_NATIVE"

        const val INCOMING_NOTIFICATION_ID = 1
        const val MISSED_NOTIFICATION_ID = 2

        fun missedNotificationTag(callUuid: String) = "missed-call-$callUuid"
        fun incomingNotificationTag(callUuid: String) = "incoming-call-$callUuid"
    }

    @RequiresApi(Build.VERSION_CODES.P)
    private fun channel(context: Context, name: String, channelId: String, vibrate: Boolean, ring: Boolean, soundNotificationType: Int): NotificationChannel {
        val channel = NotificationChannel(
            channelId,
            name,
            NotificationManager.IMPORTANCE_HIGH
        )
        channel.description = name
        channel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        channel.enableVibration(vibrate)
        channel.setShowBadge(true)
        if (vibrate or ring) {
            channel.importance = NotificationManager.IMPORTANCE_HIGH
        }
        if (ring) {
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .setLegacyStreamType(AudioManager.STREAM_RING)
                .build()
            val soundUri = RingtoneManager.getDefaultUri(soundNotificationType)
            channel.setSound(soundUri, audioAttributes)
        }
        else {
            channel.setSound(null, null)
        }

        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
        return channel
    }

    @RequiresApi(Build.VERSION_CODES.P)
    fun channel(context: Context, ringType: Int, forMissedCalls: Boolean): NotificationChannel {
        val label = if (forMissedCalls) "missed-calls" else "calls"
        val ringtone = if (forMissedCalls) RingtoneManager.TYPE_NOTIFICATION else RingtoneManager.TYPE_RINGTONE
        return  when(ringType) {
            1 -> channel(context, "Callability vibrate", "callability-vibrate-$label-5", true, false, ringtone)
            2 -> channel(context, "Callability ring", "callability-ring-$label-5", true, true, ringtone)
            else -> channel(context, "Callability silent", "callability-silent-$label-5", false, false, ringtone)
        }
    }

}