import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.Material

import "../utils"
import "../Pages"

Page {
    id: root
    SwipeView {
        id: swipeView
        currentIndex: 0
        anchors.fill: parent
        HomePage{} //HomePage
        SensorPage{}//SensorPage
    }

    footer: TabBar {
        currentIndex: swipeView.currentIndex
        //Home Button
        TabButton {
            id: home
            text: qsTr("Home")

            contentItem: Item {
                anchors.centerIn: parent

                Row {
                    spacing: 4
                    anchors.centerIn: parent

                    Image {
                        source: "qrc:/assets/com/home.png"
                        width: 38
                        height: width
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: parent.parent.parent.text
                        font: parent.parent.parent.font
                        color: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            onClicked: swipeView.currentIndex = 0
        }
        //Senso Button
        TabButton {
            id: monitor
            text: qsTr("Sensors")

            contentItem: Item {
                anchors.centerIn: parent

                Row {
                    spacing: 4
                    anchors.centerIn: parent

                    Image {
                        source: "qrc:/assets/com/sensors.png"
                        width: 38
                        height: width
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        text: parent.parent.parent.text
                        font: parent.parent.parent.font
                        color: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            onClicked: swipeView.currentIndex = 1
        }

    }
}
