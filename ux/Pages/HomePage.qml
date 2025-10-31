import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Dialogs

import "../utils"
import QtCore

Page {
    id: homeScreen
    objectName: "Home"
    property bool isDark: false
    property string imageSource: ""
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
            width: 90
            height: width
            radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            Material.elevation: 4

            Image {
                id: addImageIcon
                source: "qrc:/assets/com/adimage.png"
                width: 42
                height: width
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
                    source: "qrc:/assets/com/cancel.png"
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
                    source: "qrc:/assets/com/upload.png"
                    width: 32
                    height: width
                    fillMode: Image.PreserveAspectFit
                    anchors.centerIn: parent
                }
                onClicked: {
                    loading.visible = true
                    uploadForInfarance()
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
                Helper.setIsHompage(false)
                mainStackView.push("../Screens/CameraScreen.qml")
                avataDrawer.close()

            }
            onGalaryClicked: {
                console.log("Gallery Clicked")
                fileDialog.open()
                avataDrawer.close()
            }
        }
    }

    //--------dialgo section-----
    FileDialog {
        id: fileDialog
        title: "Select an Image"
        onAccepted: {
            console.log("Selected file:", fileDialog.selectedFile);
            var path = fileDialog.selectedFile
            Helper.loadImageFromContentUri(path)
            preveiwColumn.visible = true
            loading.visible = true
            // Process the selected file URL
        }

        onRejected: {
            console.log("File selection canceled.");
        }
    }

    //----connection section ---------------
    Connections {
        target: Helper
        function onImageReady() {
            var preview = Helper.imagePreview()
            var path = Helper.localFilePath()
            imagePreview.preview = preview || path
            loading.visible  = false
        }
        function onIsHompageChanged() {
            var state = Helper.isHompage
            if(state) {
                preveiwColumn.visible = true
                loading.visible = true
            }
        }
    }
    // --------- Function ------------------------
    function uploadForInfarance() {
        ModelRunner.classifyImage(Helper.imagePreview());
    }

    Connections {
        target: ModelRunner
        //onInfarenceFinished:
        function onInfarenceFinished () {
            loading.visible = false
            console.log(ModelRunner.diseaseName)
            mainStackView.push("InfarenceResultPage.qml")
        }
        //when the infarence faild
        function onInfarenceFaild() {

        }
    }
}
