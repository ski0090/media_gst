#include "include/media_gst/media_gst_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

namespace media_gst {

// static
void MediaGstPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto instance = std::make_unique<MediaGstPlugin>();
  registrar->AddPlugin(std::move(instance));
}

MediaGstPlugin::MediaGstPlugin() {}

MediaGstPlugin::~MediaGstPlugin() {}

}  // namespace media_gst
