
        file(APPEND "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in"
"
PackageName: Mqtt
SPDXID: SPDXRef-Package-qtmqtt-qt-module-Mqtt
PackageDownloadLocation: git://code.qt.io/qt/qtmqtt.git@b468272c57fdfcce63487aee95e4aedaa0bfe1d6
PackageVersion: 6.9.2
PackageSupplier: Organization: TheQtCompany
PackageLicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only
PackageLicenseDeclared: LicenseRef-Qt-Commercial OR GPL-3.0-only
ExternalRef: PACKAGE-MANAGER purl pkg:github/qt/qtmqtt@b468272?library_name=Mqtt#src/mqtt
ExternalRef: PACKAGE-MANAGER purl pkg:generic/TheQtCompany/qtmqtt-Mqtt@b468272?vcs_url=https://code.qt.io/qt/qtmqtt.git@b468272&library_name=Mqtt#src/mqtt
FilesAnalyzed: true
PackageCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
PrimaryPackagePurpose: LIBRARY
PackageComment: <text>
CMake target name: Mqtt
CMake exported target name: Qt6::Mqtt
Contained in CMake package: Qt6Mqtt
</text>
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qt:6.9.2:*:*:*:*:*:*:*
ExternalRef: SECURITY cpe23Type cpe:2.3:a:qt:qtmqtt:6.9.2:*:*:*:*:*:*:*
Relationship: SPDXRef-Package-qtmqtt-qt-module-Mqtt DEPENDS_ON DocumentRef-qtbase:SPDXRef-Package-qtbase-qt-module-Core
Relationship: SPDXRef-Package-qtmqtt-qt-module-Mqtt DEPENDS_ON DocumentRef-qtbase:SPDXRef-Package-qtbase-qt-module-PlatformModuleInternal
Relationship: SPDXRef-Package-qtmqtt-qt-module-Mqtt DEPENDS_ON DocumentRef-qtbase:SPDXRef-Package-qtbase-qt-module-Network
Relationship: SPDXRef-Package-qtmqtt CONTAINS SPDXRef-Package-qtmqtt-qt-module-Mqtt
"
        )
