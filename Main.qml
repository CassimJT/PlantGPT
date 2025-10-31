import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./ux/utils"
import "./ux/Screens"
import "./ux/home"
import "./ux/delegates"
import HistoryModel 1.0
ApplicationWindow {
    id: mainRoot
    width: 350
    height: 580
    visible: true
    title: qsTr("PlantGPT")
    property bool isDarkTheme: false
    property alias drawer: drawer
    flags: {
        if(Qt.platform.os === "android"){
            return Qt.FramelessWindowHint | Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
        }else {
            return Qt.Window
        }
    }
    //defalte themes
    Material.theme: Material.Dark
    Material.primary : "black"
    Material.accent : "#FF9800"
    Material.background:  "#333"


    header: Header {
        id: appHeader
        onSwitchClicked: {
            if (Material.theme === Material.Light) {
                Material.theme = Material.Dark
                Material.primary = "black"
                Material.accent = "#FF9800"
                mainRoot.Material.background = "#333"

            } else {
                Material.theme = Material.Light
                Material.primary = "#00dae4"
                Material.accent = "#FF9800"
                mainRoot.Material.background =  "#f0fff0"

            }
        }

        onThemeChanged: {
            isDarkTheme = !isDarkTheme
        }
        //when meni is menuClicked:
        onMenuClicked: {
            if(mainLoader.item && mainLoader.item.mainStackView.depth > 1) {
                mainLoader.item.mainStackView.pop()
            }else {
                drawer.open();
            }
        }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        source:"./ux/home/MainStackView.qml"
    }

    Drawer {
        id: drawer
        width: parent.width * 0.85
        height: parent.height
        padding: 10
        Material.background:  "#333"

        SearchField {
            id: searchField
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                margins: 10
            }

        }
        Label {
            id: hisoryLable
            text: qsTr("History")
            font.pointSize: 20
            anchors {
                top: searchField.bottom
                left: parent.left
                margins: 10
            }
        }

        Rectangle {
            id: frame
            width: 1
            color: "#9E9E9E"
            anchors {
                top: hisoryLable.bottom
                left: parent.left
                bottom: parent.bottom
                leftMargin: 25
                topMargin: 10
                bottomMargin: 10
            }
        }
       ListView {
           id: view
           clip: true
           model: HistoryModel.listmodel
           delegate: HistoryDelegate{}

           anchors {
               top: hisoryLable.bottom
               right: parent.right
               bottom: parent.bottom
               left: frame.right
           }

       }
       RoundButton {
           id: roundBtn
           width: 56
           height: width
           z: 10
           radius: width / 2
           Material.elevation: 8
           anchors {
               right: parent.right
               bottom: parent.bottom
               rightMargin: 25
           }

           Image {
               id: clear
               source: "qrc:/assets/com/clear.png"
               width: 28
               height: width
               anchors.centerIn: parent
               fillMode: Image.PreserveAspectFit
           }

           onClicked: {
               HistoryModel.clearModel()
           }
       }
    }
}
