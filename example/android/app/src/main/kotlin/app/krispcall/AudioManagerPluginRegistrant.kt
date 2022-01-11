package app.krispcall

import cc.dync.audio_manager.AudioManagerPlugin
import io.flutter.plugin.common.PluginRegistry

object AudioManagerPluginRegistrant {
    fun registerWith(registry: PluginRegistry) {
        if (alreadyRegisteredWith(registry)) {
            return
        }
        AudioManagerPlugin.registerWith(registry.registrarFor("cc.dync.audio_manager.AudioManagerPlugin"))
    }

    private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
        val key = AudioManagerPluginRegistrant::class.java.canonicalName
        if (registry.hasPlugin(key)) {
            return true
        }
        registry.registrarFor(key)
        return false
    }
}