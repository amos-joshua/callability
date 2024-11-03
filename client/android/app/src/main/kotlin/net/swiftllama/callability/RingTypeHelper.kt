package net.swiftllama.callability

import android.content.Context
import android.content.Context.AUDIO_SERVICE
import android.media.AudioManager
import android.os.Build
import androidx.annotation.RequiresApi

class RingTypeHelper {
    private var previousRingerMode: Int? = null

    // Note: the values here correspond to
    //   - RINGER_MODE_SILENT
    //   - RINGER_MODE_VIBRATE
    //   - RINGER_MODE NORMAL
    // from https://developer.android.com/reference/android/media/AudioManager#RINGER_MODE_NORMAL
    @RequiresApi(Build.VERSION_CODES.P)
    fun setRingMode(context: Context, desiredRingerMode: Int) {
        val audioService = context.getSystemService(AUDIO_SERVICE) as AudioManager
        if (audioService.ringerMode != desiredRingerMode) {
            previousRingerMode = audioService.ringerMode
            audioService.ringerMode = desiredRingerMode
        }
    }

    fun restorePreviousRingerMode(context: Context) {
        val ringerMode = previousRingerMode
        if (ringerMode != null) {
            val audioService = context.getSystemService(AUDIO_SERVICE) as AudioManager
            audioService.ringerMode = ringerMode
            previousRingerMode = null
        }
    }

}