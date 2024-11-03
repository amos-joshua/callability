package net.swiftllama.callability

import android.graphics.Color
import android.media.AudioManager
import android.media.RingtoneManager

class DartNotificationArguments(val callUuid: String, val contactName: String, val subject: String, val urgency: Int, val ringType: Int) {
  companion object {
      fun from(arguments: List<*>): DartNotificationArguments {
          if (arguments.size != 5) {
              throw IllegalArgumentException("Expected an argumwnts list with 5 elements but found ${arguments.size} elements")
          }
          return DartNotificationArguments(
              validate(arguments, 0),
              validate(arguments, 1),
              validate(arguments, 2),
              validate(arguments, 3),
              validate(arguments, 4),
          )
      }

      private inline fun <reified T> validate(arguments: List<*>, index: Int): T {
          if (arguments[index] !is T) {
              throw IllegalArgumentException("Expected item at index $index to be a ${T::class.java.name} but found ${arguments[index]?.javaClass}")
          }
          return arguments[index] as T
      }
  }

    fun urgencyColor(): Int = when(urgency) {
        1 -> Color.rgb(196, 196, 0)
        2 -> Color.rgb(196, 0, 0)
        else -> Color.rgb(0, 196, 0)
    }

    fun urgencyAndSubject(): String = if (subject.isBlank()) urgencyLabel() else "${urgencyLabel()}: ${subject.trim()}"

    private fun urgencyLabel(): String = when(urgency) {
        1 -> "IMPORTANT"
        2 -> "URGENT"
        else -> ""
    }

    fun ringerMode(): Int = when(ringType) {
        1 -> AudioManager.RINGER_MODE_VIBRATE
        2 -> AudioManager.RINGER_MODE_NORMAL
        else -> AudioManager.RINGER_MODE_SILENT
    }

}