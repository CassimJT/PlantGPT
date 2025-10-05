
        cmake_minimum_required(VERSION 3.16)
        message(STATUS "Starting SBOM generation in build dir: /home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in")
        set(QT_SBOM_EXTERNAL_DOC_REFS "")
        file(READ "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/SPDXRef-DOCUMENT-qtmqtt.spdx.in" content)
        # Override any previous file because we're starting from scratch.
        file(WRITE "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Desktop_Qt_6_9_2-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in" "${content}")
