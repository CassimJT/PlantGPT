import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "./ux/utils"
ApplicationWindow {
    id: root
    width: 350
    height: 580
    visible: true
    title: qsTr("PlantGPT")
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
        //header
        onSwitchClicked: {
            if (Material.theme === Material.Light) {
                Material.theme = Material.Dark
                Material.primary = "black"
                Material.accent = "#FF9800"
                root.Material.background = "#333"
            } else {
                Material.theme = Material.Light
                Material.primary = "#2196F3"
                Material.accent = "#FF9800"
                root.Material.background =  "#fafafa"

            }
        }
    }

}
