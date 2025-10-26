import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "Utils.js" as Utills
import "../home"
Item {
    id: root
    signal switchClicked()
    signal themeChanged()
    signal menuClicked()
    property real h_height: 70
    Rectangle {
        id: header
        width: parent.width
        height: root.h_height
        ToolBar {
            id: tooBar
            anchors.fill: parent
            RowLayout{
                id: row
                visible: header.height === root.h_height
                width: parent.width
                height: parent.height
                ToolButton {
                    id: menu
                    Image {
                        id: icon
                        width: 30
                        height: width
                        source: {
                            if(mainLoader.item && mainLoader.item.mainStackView.depth > 1) {
                                if(Material.theme === Material.Dark ) {
                                    return "qrc:/asserts/dark/back.png"
                                } else if(Material.theme === Material.Light){
                                    return "qrc:/asserts/light/back.png"
                                }
                            } else {
                                if(Material.theme === Material.Light ) {
                                    return "qrc:/asserts/light/menu.png"
                                } else if(Material.theme === Material.Dark){
                                    return "qrc:/asserts/dark/menu.png"
                                }
                            }


                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        menuClicked()
                    }
                }
                Label {
                    id: tittle
                    text: qsTr("PlantGPT")
                }
                Switch {
                    id: mode
                    text: checked ? "Dark" : "Light"
                    Layout.alignment: Qt.AlignRight
                    onClicked: {
                        switchClicked()
                        themeChanged()
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
        opacity: 0.5
        source: header.height > root.h_height ? "qrc:/asserts/dark/top_curtain_drag_back.png": "qrc:/asserts/dark/top_curtain_drag.png"
        fillMode: Image.PreserveAspectFit
        anchors {
            top: header.bottom
            topMargin: 0
            horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: timeLable
            text: Utills.getCurrentTime()
            color: "#FAFAFA"
            visible: header.height === root.h_height
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked:  {
                if(header.height === root.h_height) {
                    header.height = root.parent.height * 0.30
                } else if( header.height > root.h_height) {
                    header.height = root.h_height
                }
            }
        }
    }
    Timer {
        id:updateCurrentTime
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeLable.text = Utills.getCurrentTime()
        }
    }

}

