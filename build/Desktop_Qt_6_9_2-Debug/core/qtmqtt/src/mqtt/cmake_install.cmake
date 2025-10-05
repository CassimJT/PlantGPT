# Install script for directory: /home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/opt/Qt/6.9.2/gcc_64")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/./metatypes" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/meta_types/qt6mqtt_debug_metatypes.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttConfig.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttConfigVersion.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttConfigVersionImpl.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateConfig.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateConfigVersion.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateConfigVersionImpl.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt.so.6.9.2"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt.so.6"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "\$ORIGIN")
    endif()
  endforeach()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/libQt6Mqtt.so.6.9.2"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/libQt6Mqtt.so.6"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt.so.6.9.2"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt.so.6"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHANGE
           FILE "${file}"
           OLD_RPATH "/opt/Qt/6.9.2/gcc_64/lib:"
           NEW_RPATH "\$ORIGIN")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/libexec/qt-internal-strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/libQt6Mqtt.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt/Qt6MqttTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt/Qt6MqttTargets.cmake"
         "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/CMakeFiles/Export/4fad7c2282f83b62338f8317ce35cfb1/Qt6MqttTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt/Qt6MqttTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt/Qt6MqttTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/CMakeFiles/Export/4fad7c2282f83b62338f8317ce35cfb1/Qt6MqttTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/CMakeFiles/Export/4fad7c2282f83b62338f8317ce35cfb1/Qt6MqttTargets-debug.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttVersionlessAliasTargets.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateTargets.cmake"
         "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/CMakeFiles/Export/dac601b1891e607c607dfe086e9e4bc2/Qt6MqttPrivateTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/mqtt/CMakeFiles/Export/dac601b1891e607c607dfe086e9e4bc2/Qt6MqttPrivateTargets.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateVersionlessAliasTargets.cmake"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateVersionlessTargets.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/Qt6Mqtt.debug")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/modules" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/modules/Mqtt.json")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_html_docs_Mqtt")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc/qtmqtt" TYPE DIRECTORY FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/doc/qtmqtt/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "_install_qch_docs_Mqtt")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/doc" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/doc/qtmqtt.qch")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateAdditionalTargetInfo.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtMqtt" TYPE DIRECTORY FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/include/QtMqtt/.syncqt_staging/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtMqtt" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/include/QtMqtt/qtmqttexports.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttauthenticationproperties.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttclient.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttconnectionproperties.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttglobal.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttmessage.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttpublishproperties.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttsubscription.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttsubscriptionproperties.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqtttopicfilter.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqtttopicname.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqtttype.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/include/QtMqtt/QtMqttDepends"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/QtMqtt/6.9.2/QtMqtt/private" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttclient_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttconnection_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttconnectionproperties_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttcontrolpacket_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttglobal_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttmessage_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttpublishproperties_p.h"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt/src/mqtt/qmqttsubscription_p.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/mkspecs/modules" TYPE FILE FILES
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/mkspecs/modules/qt_lib_mqtt.pri"
    "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/mkspecs/modules/qt_lib_mqtt_private.pri"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/pkgconfig/Qt6Mqtt.pc")
endif()

