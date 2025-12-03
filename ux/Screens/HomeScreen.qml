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
            icon.source: "qrc:/assets/com/home.svg"
            Material.foreground: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
            icon.color: Qt.rgba(0,0,0,0)
            icon.width: 32
            icon.height: 32
            onClicked: swipeView.currentIndex = 0
        }
        //Senso Button
        TabButton {
            id: monitor
            text: qsTr("Sensors")
            icon.source: "qrc:/assets/com/sensors.svg"
            Material.foreground: mainRoot.isDarkTheme ? "#000814" : "#ffffff"
            icon.color: Qt.rgba(0,0,0,0)
            icon.width: 38
            icon.height: 38
            onClicked: swipeView.currentIndex = 1
        }

    }
}
