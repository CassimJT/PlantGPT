import QtQuick
import QtQuick.Controls



Rectangle {
    id: imageBgd

    property real imgWidth: 50
    property real imgHeight: 50
    property real recWidth: 150
    property real recHeight: 150
    property string preview: ""
    property real recRadius: 15
    property color recColor: "gray"

    width: imageBgd.recWidth
    height: imageBgd.recHeight
    radius: imageBgd.recRadius
    color: imageBgd.recColor
    clip: true

    Image {
        id: name
        source: imageBgd.preview
        width: parent.width * 0.80
        height: parent.height  * 0.80
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

}

