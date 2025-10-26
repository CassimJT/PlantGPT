import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import "../utils"
import QtCore

Page {
    id: homeScreen
    objectName: "Home"
    property bool isDark: false
    property bool isDialogOpen: false
// -----welcom text section -----
    Column {
        id: column
        width: parent.width * 0.8
        spacing: 40
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.30
        }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: welcomeText
                text: qsTr("Welcome to PlantGPT")
                font.pixelSize: 24
                font.weight: Font.Medium
                color: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
            }

            Text {
                text: qsTr("Your intelligent plant diagnostic tool")
                font.pixelSize: 16
                color: "#757575"
                anchors.horizontalCenter: parent.horizontalCenter
                wrapMode: Text.WordWrap
            }
        }


        RoundButton {
            id: addFileButton
            width: 80
            height: width
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            Material.elevation: 4

            Image {
                id: addImageIcon
                source: "qrc:/asserts/com/adimage.png"
                width: 36
                height: 36
                fillMode: Image.PreserveAspectFit
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: avataDrawer.open()
            }
        }
    }
// -------- ImagePreview section
    ColumnLayout {
        id: preveiwColumn
        spacing: 20
        visible: false
        anchors {
            top: column.bottom
            horizontalCenter: parent.horizontalCenter
        }

        ImagePreview {
            id: imagePreview
            Layout.alignment: Qt.AlignHCenter
            BusyIndicator {
                id: loading
                anchors.centerIn: parent
                visible: false
            }
        }

        Row {
            spacing: 20
            Layout.alignment: Qt.AlignHCenter
            RoundButton {
                id: cancel
                width: 70
                height: width
                Image {
                    source: "qrc:/asserts/com/cancel.png"
                    width: 32
                    height: width
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
                onClicked: {
                    imagePreview.preview = ""
                    preveiwColumn.visible = false
                }
            }

            RoundButton {
                id: uploadBtn
                width: 70
                height: width
                Image {
                    id: upload
                    source: "qrc:/asserts/com/upload.png"
                    width: 32
                    height: width
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
                onClicked: {

                }
            }
        }

    }

//-------drawer section --------
    Drawer {
        id: avataDrawer
        width: parent.width
        height: parent.height * 0.3
        dragMargin: 0
        edge: Qt.BottomEdge
        dim: true


        Rectangle {
            id: handle
            width: 60
            height: 4
            radius: 2
            color: Material.theme === Material.Dark ? "#95A5A6" : "#BDC3C7"
            anchors {
                top: parent.top
                topMargin: 12
                horizontalCenter: parent.horizontalCenter
            }
        }

        AvataDrawerTools {
            id: tools
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            onCameraClicked: {
                console.log("Camera clicked")
                //open camea Page
                helper.setIsHompage(false)
                mainStackView.push("../Screens/CameraScreen.qml")
                avataDrawer.close()

            }
            onGalaryClicked: {
                console.log("Gallery Clicked")
                avataDrawer.close()
            }
        }
    }

    //--------dialgo section-----
    Connections {
        target: helper
        function onImageReady() {
            var preview = helper.imagePreview()
            imagePreview.preview = preview
            loading.visible  = false
        }
        function onIsHompageChanged() {
            var state = helper.isHompage
            if(state) {
                preveiwColumn.visible = true
                loading.visible = true
            }
        }
    }
}
