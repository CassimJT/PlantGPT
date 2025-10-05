#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::Mqtt" for configuration "Debug"
set_property(TARGET Qt6::Mqtt APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(Qt6::Mqtt PROPERTIES
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libQt6Mqtt.so.6.9.2"
  IMPORTED_SONAME_DEBUG "libQt6Mqtt.so.6"
  )

list(APPEND _cmake_import_check_targets Qt6::Mqtt )
list(APPEND _cmake_import_check_files_for_Qt6::Mqtt "${_IMPORT_PREFIX}/lib/libQt6Mqtt.so.6.9.2" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
