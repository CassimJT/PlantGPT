import QtQuick
import QtQuick.Controls

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("PlantGPT")
    flags: {
        if(Qt.platform.os === "android"){
            return Qt.FramelessWindowHint | Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
        }else {
            return Qt.Window
        }
    }

}
