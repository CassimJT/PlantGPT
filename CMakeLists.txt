cmake_minimum_required(VERSION 3.16)

project(PlantGPT VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
add_subdirectory(core/qtmqtt)
if(ANDROID)
    message(STATUS ">>> Building for Android <<<")

    # Path to your Android SDK OpenCV
    set(OpenCV_DIR "$ENV{HOME}/CISociety/Libs/OpenCV-android-sdk/sdk/native/jni")
     # ==== THE PORTABLE WAY TO FIND LIBTORCH ====
     #add the libtoch librally via gradle under depenced section

else()
    message(STATUS ">>> Building for Desktop Linux <<<")
    # Path to your locally built desktop OpenCV
    set(OpenCV_DIR "$ENV{HOME}/CISociety/Libs/opencv-install/lib/cmake/opencv4")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPlantGPT
    main.cpp
    resources.qrc
)

qt_add_qml_module(appPlantGPT
    URI PlantGPT
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES
            core/sources/androidsystem.h
            core/sources/androidsystem.cpp
        QML_FILES
            ux/utils/CircularProgressBar.qml
            ux/utils/DHTMeter.qml
        RESOURCES
            android/AndroidManifest.xml
            android/build.gradle
            android/res/values/libs.xml
            android/res/xml/qtprovider_paths.xml
            android/gradle/wrapper/gradle-wrapper.jar
            android/gradle/wrapper/gradle-wrapper.properties
            android/gradle.properties
            android/gradlew android/gradlew.bat
            android/AndroidManifest.xml
            android/build.gradle
            android/res/values/libs.xml
            android/res/xml/qtprovider_paths.xml
            QML_FILES ux/utils/Header.qml


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPlantGPT PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPlantGPT
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPlantGPT
    PRIVATE Qt6::Quick
)
target_link_libraries(appPlantGPT PRIVATE Qt6::Core)
set_property(TARGET appPlantGPT APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

include(GNUInstallDirs)
install(TARGETS appPlantGPT
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
