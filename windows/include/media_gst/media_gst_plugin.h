#ifndef FLUTTER_PLUGIN_MEDIA_GST_PLUGIN_H_
#define FLUTTER_PLUGIN_MEDIA_GST_PLUGIN_H_

#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace media_gst {

class MediaGstPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MediaGstPlugin();

  virtual ~MediaGstPlugin();

  // Disallow copy and assign.
  MediaGstPlugin(const MediaGstPlugin&) = delete;
  MediaGstPlugin& operator=(const MediaGstPlugin&) = delete;
};

}  // namespace media_gst

#endif  // FLUTTER_PLUGIN_MEDIA_GST_PLUGIN_H_
