cmake_minimum_required(VERSION 3.16)

project(PlantGPT VERSION 0.1 LANGUAGES CXX)

# -------------------------
# C++ / Qt setup
# -------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# -------------------------
# Platform-specific configuration
# -------------------------
if(ANDROID)
    message(STATUS ">>> Building for Android <<<")

    # Android NDK toolchain
    set(CMAKE_TOOLCHAIN_FILE "$ENV{HOME}/Android/Sdk/ndk/27.2.12479018/build/cmake/android.toolchain.cmake")

    # Prefer 64-bit ABI to avoid ARMv7 ExecuTorch issues
    set(ANDROID_ABI "arm64-v8a")
    set(ANDROID_PLATFORM "android-34")

    # -------------------------
    # ExecuTorch minimal configuration
    # -------------------------
    # Disable optional modules/extensions
    #set(EXECUTORCH_BUILD_PRESET_FILE ${CMAKE_SOURCE_DIR}/executorch/tools/cmake/preset/llm.cmake)
    set(EXECUTORCH_BUILD_EXTENSION_LLM OFF CACHE BOOL "Disable LLM extension")
    set(EXECUTORCH_BUILD_EXTENSION_EVALUATION OFF CACHE BOOL "Disable evaluation extensions")
    set(EXECUTORCH_BUILD_EXTENSION_RUNNER OFF CACHE BOOL "Disable runner extensions")
    set(EXECUTORCH_BUILD_EXAMPLES OFF CACHE BOOL "Disable examples")
    set(EXECUTORCH_BUILD_TESTS OFF CACHE BOOL "Disable tests")
    set(EXECUTORCH_BUILD_PORTABLE_OPS OFF CACHE BOOL "Disable portable ops for Android")
    set(EXECUTORCH_ENABLE_PORTABLE_KERNELS OFF CACHE BOOL "Disable portable kernels for Android")
    # Backends
    set(EXECUTORCH_BUILD_XNNPACK ON CACHE BOOL "Enable XNNPACK backend for Android")
    set(EXECUTORCH_BUILD_QNN OFF CACHE BOOL "")
    set(EXECUTORCH_BUILD_VULKAN OFF CACHE BOOL "")
    # Core high-level extensions + dep chain (passes checks)
    set(EXECUTORCH_BUILD_EXTENSION_MODULE ON CACHE BOOL "Enable Module API extension")
    set(EXECUTORCH_BUILD_EXTENSION_TENSOR ON CACHE BOOL "Enable Tensor convenience APIs")
    set(EXECUTORCH_BUILD_EXTENSION_DATA_LOADER ON CACHE BOOL "Req for Module")
    set(EXECUTORCH_BUILD_EXTENSION_FLAT_TENSOR ON CACHE BOOL "Req for Module")
    set(EXECUTORCH_BUILD_EXTENSION_NAMED_DATA_MAP ON CACHE BOOL "Req for Module")
    set(EXECUTORCH_ENABLE_LOGGING OFF CACHE BOOL "Disable logging")

else()
    message(STATUS ">>> Building for Desktop Linux <<<")
    set(OpenCV_DIR "$ENV{HOME}/CISociety/Libs/opencv-install/lib/cmake/opencv4")
endif()

# -------------------------
# Qt setup
# -------------------------
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Multimedia Concurrent Core)
find_package(Qt6 REQUIRED COMPONENTS Core)
qt_standard_project_setup(REQUIRES 6.8)

# -------------------------
# Add subdirectories
# -------------------------
add_subdirectory(core/qtmqtt)

# -------------------------
# Executable target
# -------------------------
qt_add_executable(appPlantGPT
    main.cpp
    resources.qrc
)

# -------------------------
# QML module
# -------------------------
qt_add_qml_module(appPlantGPT
    URI PlantGPT
    VERSION 1.0
    QML_FILES
    Main.qml
    ux/utils/CircularProgressBar.qml
    ux/utils/DHTMeter.qml
    ux/utils/Header.qml
    ux/utils/Utils.js
    ux/Screens/HomeScreen.qml
    ux/home/MainStackView.qml
    ux/utils/AvataDrawerTools.qml
    ux/Screens/CameraScreen.qml
    ux/Pages/CameraPage.qml
    ux/Pages/HomePage.qml
    ux/Pages/SensorPage.qml
    ux/utils/ImagePreview.qml
    SOURCES
    core/sources/androidsystem.h
    core/sources/androidsystem.cpp
    core/sources/myhelper.h
    core/sources/myhelper.cpp
    core/sources/myhelper.cpp
    core/sources/myhelper.cpp
    SOURCES core/sources/modelrunner.h core/sources/modelrunner.cpp
)

#open cv

if(ANDROID)
    message(STATUS ">>> Building for Android <<<")

    # Android OpenCV path
    set(OpenCV_DIR "$ENV{HOME}/CISociety/Libs/OpenCV-android-sdk/sdk/native/jni")
    find_package(OpenCV REQUIRED)

    target_include_directories(appPlantGPT PRIVATE ${OpenCV_INCLUDE_DIRS})
    target_link_libraries(appPlantGPT PRIVATE ${OpenCV_LIBS})
endif()
# -------------------------
# Link Qt libraries
# -------------------------

target_link_libraries(appPlantGPT
    PRIVATE
    Qt6::Quick
    Qt6::Multimedia
    Qt6::Concurrent
    Qt6::Core
)
target_include_directories(appPlantGPT PRIVATE
    ${LIBTORCH_DIR}/include
    ${OpenCV_INCLUDE_DIRS}
)
# -------------------------
# Add ExecuTorch minimal build
# -------------------------
add_subdirectory(
    ${CMAKE_SOURCE_DIR}/core/executorch
    ${CMAKE_BINARY_DIR}/executorch_build
    EXCLUDE_FROM_ALL
)

target_link_libraries(appPlantGPT
    PRIVATE
    executorch
    executorch::backends
    executorch::extensions
   # executorch::kernels

)

target_link_libraries(appPlantGPT PRIVATE Qt6::Core)

target_include_directories(appPlantGPT PRIVATE ${CMAKE_SOURCE_DIR}/core/executorch)

# -------------------------
# Android packaging
# -------------------------
if(ANDROID)
    set_property(TARGET appPlantGPT APPEND PROPERTY
        QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
    )
endif()

# -------------------------
# Install rules
# -------------------------
include(GNUInstallDirs)
install(TARGETS appPlantGPT
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
