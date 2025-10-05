
        if(NOT EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt_armeabi-v7a.so"
                AND NOT QT_SBOM_BUILD_TIME AND NOT QT_SBOM_FAKE_CHECKSUM)
            if(NOT FALSE)
                message(FATAL_ERROR "Cannot find 'lib/libQt6Mqtt_armeabi-v7a.so' to compute its checksum. "
                    "Expected to find it at '$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt_armeabi-v7a.so' ")
            endif()
        else()
            if(NOT QT_SBOM_BUILD_TIME)
                if(QT_SBOM_FAKE_CHECKSUM)
                    set(sha1 "158942a783ee1095eafacaffd93de73edeadbeef")
                else()
                    file(SHA1 "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libQt6Mqtt_armeabi-v7a.so" sha1)
                endif()
                list(APPEND QT_SBOM_VERIFICATION_CODES ${sha1})
            endif()
            file(APPEND "/home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/core/qtmqtt/qt_sbom/staging-qtmqtt.spdx.in"
"
FileName: ./lib/libQt6Mqtt_armeabi-v7a.so
SPDXID: SPDXRef-PackagedFile-qt-module-Mqtt
FileType: BINARY
FileChecksum: SHA1: ${sha1}
LicenseConcluded: LicenseRef-Qt-Commercial OR GPL-3.0-only
FileCopyrightText: <text>Copyright (C) The Qt Company Ltd. and other contributors.</text>
LicenseInfoInFile: NOASSERTION
Relationship: SPDXRef-Package-qtmqtt-qt-module-Mqtt CONTAINS SPDXRef-PackagedFile-qt-module-Mqtt
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /home/csociety/CISociety/Qt/Projects/PlantGPT/PlantGPT/build/Android_Qt_6_9_2_Clang_armeabi_v7a-Debug/include/QtMqtt/qtmqttexports.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttauthenticationproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttauthenticationproperties.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttclient.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttclient.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttclient_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttconnection.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttconnection_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttconnectionproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttconnectionproperties.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttconnectionproperties_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttcontrolpacket.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttcontrolpacket_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttglobal.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttglobal_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttmessage.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttmessage.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttmessage_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttpublishproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttpublishproperties.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttpublishproperties_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttsubscription.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttsubscription.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttsubscription_p.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttsubscriptionproperties.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqttsubscriptionproperties.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttopicfilter.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttopicfilter.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttopicname.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttopicname.h
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttype.cpp
Relationship: SPDXRef-PackagedFile-qt-module-Mqtt GENERATED_FROM NOASSERTION
RelationshipComment: /src_dir/qtmqtt/src/mqtt/qmqtttype.h
"
                )
        endif()
