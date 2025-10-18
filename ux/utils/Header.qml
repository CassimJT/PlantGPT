import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
Item {
    id: root
    signal switchClicked()
    Rectangle {
        id: header
        width: parent.width
        height: 50
        ToolBar {
            id: tooBar
            anchors.fill: parent
            RowLayout{
                id: row
                visible: header.height === 50
                width: parent.width
                height: parent.height
                ToolButton {
                    id: menu
                    icon.source: "qrc:/asserts/dark/list_selected.png"
                }
                Label {
                    id: tittle
                    text: qsTr("PlantGPT")
                }
                Switch {
                    id: mode
                    text: checked ? "dark" : "light"
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        switchClicked()
                    }
                }
            }

        }

        //animation
        Behavior on height {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
    }

    Image {
        id: handle
        width: 152
        height: 45
        source: header.height > 50 ? "qrc:/asserts/dark/top_curtain_drag_back.png": "qrc:/asserts/dark/top_curtain_drag.png"
        fillMode: Image.PreserveAspectFit
        anchors {
            top: header.bottom
            topMargin: 0
            horizontalCenter: parent.horizontalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked:  {
                if(header.height === 50) {
                    header.height = root.parent.height * 0.30
                } else if( header.height > 50) {
                    header.height = 50
                }
            }
        }
    }
}

