import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./ux/utils"
import "./ux/Screens"
import "./ux/home"
ApplicationWindow {
    id: mainRoot
    width: 350
    height: 580
    visible: true
    title: qsTr("PlantGPT")
    property bool isDarkTheme: false
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
        width: parent.width * 0.75
        height: parent.height
        z:5
        SearchField {
            id: searchField
            anchors {
                left: parent.left
                leftMargin: 10
            }



        }

    }
}
