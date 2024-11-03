package net.swiftllama.callability

import android.app.*
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.RequiresApi


class PermissionsHelper {
    @RequiresApi(Build.VERSION_CODES.O_MR1)
    fun hasAccessNotificationPolicyPermissions(context: Context): Boolean {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return notificationManager.isNotificationPolicyAccessGranted
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun requestAccessNotificationPolicyPermissions(activity: MainActivity) {
        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
        activity.startActivity(intent)
    }

}