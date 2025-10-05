# Install script for directory: /home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/core/qtmqtt

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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for the subdirectory.
  include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/src/cmake_install.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6Mqtt" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6Mqtt/Qt6MqttDependencies.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6MqttPrivate" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6MqttPrivate/Qt6MqttPrivateDependencies.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Devel" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/Qt6BuildInternals/StandaloneTests" TYPE FILE FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/cmake/Qt6BuildInternals/StandaloneTests/QtMqttTestsConfig.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE DIRECTORY FILES "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/lib/" FILES_MATCHING REGEX "/[^/]*\\.prl$")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "sbom" OR NOT CMAKE_INSTALL_COMPONENT)
  
        set(QT_SBOM_INSTALLED_ALL_CONFIGS TRUE)
        
        if(QT_SBOM_INSTALLED_ALL_CONFIGS)
            set(QT_SBOM_BUILD_TIME FALSE)
            set(QT_SBOM_OUTPUT_DIR "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/sbom")
            set(QT_SBOM_OUTPUT_PATH "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/sbom/qtmqtt-6.9.2.spdx")
            set(QT_SBOM_OUTPUT_PATH_WITHOUT_EXT "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/sbom/qtmqtt-6.9.2")
            file(MAKE_DIRECTORY "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/sbom")
            include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/assemble_sbom.cmake")
            
            list(SORT QT_SBOM_VERIFICATION_CODES)
            string(REPLACE ";" "" QT_SBOM_VERIFICATION_CODES "${QT_SBOM_VERIFICATION_CODES}")
            file(WRITE "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/verification.txt" "${QT_SBOM_VERIFICATION_CODES}")
            file(SHA1 "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/verification.txt" QT_SBOM_VERIFICATION_CODE)
            
            message(STATUS "Finalizing SBOM generation in install dir: ${QT_SBOM_OUTPUT_PATH}")
            configure_file("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in" "${QT_SBOM_OUTPUT_PATH}")
            
            
            
        else()
            message(STATUS "Skipping SBOM finalization because not all configs were installed.")
        endif()

endif()

