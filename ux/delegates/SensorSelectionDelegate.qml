import QtQuick
import QtQuick.Controls

Item {
    id: wrapper
    required property url icon
    required property string name
    required property int index


    width: 100
    height: 100

    Behavior on scale {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
    }
    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    scale: PathView.isCurrentItem ? 1 : 0.5
    opacity: PathView.isCurrentItem ? 1 : 0.3

    Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: 52
        height: 52
        source: wrapper.icon
        fillMode: Image.PreserveAspectFit
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: wrapper.name
        font.pointSize: 14
        color: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log(wrapper.index)
            swipeView.currentIndex = wrapper.index
        }
    }
}
