
        # QT_SBOM_BUILD_TIME be set to FALSE at install time, so don't override if it's set.
        # This allows reusing the same cmake file for both build and install.
        if(NOT DEFINED QT_SBOM_BUILD_TIME)
            set(QT_SBOM_BUILD_TIME TRUE)
        endif()
        if(NOT QT_SBOM_OUTPUT_PATH)
            set(QT_SBOM_OUTPUT_DIR "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/sbom")
            set(QT_SBOM_OUTPUT_PATH "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/sbom/qtmqtt-6.9.2.spdx")
            set(QT_SBOM_OUTPUT_PATH_WITHOUT_EXT "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/sbom/qtmqtt-6.9.2")
            file(MAKE_DIRECTORY "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/sbom")
        endif()
        set(QT_SBOM_VERIFICATION_CODES "")
        include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/append_document_to_staging.cmake")
include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/SPDXRef-Package-qtmqtt-qt-module-Mqtt.cmake")
include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/SPDXRef-PackagedFile-qt-module-Mqtt.cmake")
include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/SPDXRef-LicenseRef-Qt-Commercial-0.cmake")
include("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/DocumentRef-qtbase.cmake")
        if(QT_SBOM_BUILD_TIME)
            message(STATUS "Finalizing SBOM generation in build dir: ${QT_SBOM_OUTPUT_PATH}")
            configure_file("/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in" "${QT_SBOM_OUTPUT_PATH}")
            
        endif()
