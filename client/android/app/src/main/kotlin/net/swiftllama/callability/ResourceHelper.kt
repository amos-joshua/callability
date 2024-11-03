package net.swiftllama.callability

import android.content.Context
import android.graphics.drawable.Icon
import android.os.Build
import androidx.annotation.RequiresApi

class ResourceHelper {
    @RequiresApi(Build.VERSION_CODES.M)
    fun callIcon(context: Context, urgency: Int): Icon = Icon.createWithResource(
        context,
        when(urgency) {
            2 -> R.drawable.call_icon_urgent
            1 -> R.drawable.call_icon_important
            else -> R.drawable.call_icon_leisure
        } as Int
    )

    @RequiresApi(Build.VERSION_CODES.M)
    fun missedCallIcon(context: Context, urgency: Int): Icon = Icon.createWithResource(
        context,
        when(urgency) {
            2 -> R.drawable.missed_call_urgent
            1 -> R.drawable.missed_call_important
            else -> R.drawable.missed_call_leisure
        } as Int
    )

    @RequiresApi(Build.VERSION_CODES.M)
    fun appIcon(context: Context): Icon = Icon.createWithResource(context, R.drawable.app_icon)
}