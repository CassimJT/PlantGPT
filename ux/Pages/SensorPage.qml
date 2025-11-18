import QtQuick 2.15
import QtQuick.Controls
import "../delegates"
import "../models"
import "../utils"

Page {
    id: sensor
    property alias swipeView: swipeView
    SwipeView {
        id: swipeView
        height: parent.height * 0.8
        currentIndex: view.currentIndex
        Behavior on currentIndex {
             NumberAnimation {
                 duration: 400
                 easing.type: Easing.InOutQuad
             }
         }
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            right: parent.right
        }

        // Example pages
        Page {
            DHTMeter {
                id: dhtMeter
                anchors.centerIn: parent
                t_value: DeviceInterface.temperature
                h_value: DeviceInterface.humidity
                stateLabel: DeviceInterface.connected ? "ON" : "OFF"
                onConnectClicked: {
                    DeviceInterface.establishConnection()
                }
            }
        }
        RTSCameraPage {

        }

        Page {
            BusyIndicator {
                anchors.centerIn: parent
            }
        }
    }


    PathView {
        id: view
        anchors {
            top: swipeView.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        model: SensorSelectionModel{}
        delegate: SensorSelectionDelegate{ }
        focus: true
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        highlightMoveDuration : 400

        path: Path {
            startX: view.width * 0.2;
            startY: swipeView.currentIndex === 1 ? view.height * 0.5 : view.height * 0.1
            PathLine {
                x: view.width * 0.8;
                y: swipeView.currentIndex === 1 ? view.height * 0.5 : view.height * 0.1
            }
        }
        currentIndex: swipeView.currentIndex
    }

    Connections {
        target: DeviceInterface
        function onConnectionEstablished(state) {
            console.log(state)
            if(!state) {
                dhtMeter.t_value = 0
                dhtMeter.h_value = 0
            }

        }
    }
}
