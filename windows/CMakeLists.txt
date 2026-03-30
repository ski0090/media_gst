cmake_minimum_required(VERSION 3.14)

project(media_gst_windows LANGUAGES CXX)

add_library(media_gst_plugin SHARED
  "media_gst_plugin.cpp"
)

target_compile_definitions(media_gst_plugin PUBLIC FLUTTER_PLUGIN_IMPL)

target_include_directories(media_gst_plugin PUBLIC
  "include"
)

# Standard Flutter plugin targets
apply_standard_settings(media_gst_plugin)

target_link_libraries(media_gst_plugin PRIVATE
  flutter
  flutter_wrapper_plugin
)
