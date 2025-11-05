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
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            right: parent.right
        }

        // Example pages
        Page {
            DHTMeter {
                anchors.centerIn: parent
            }
        }
        Page {
            BusyIndicator {
                anchors.centerIn: parent
            }
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
            startY: view.height * 0.1
            PathLine { x: view.width * 0.8; y: view.height * 0.1 }
        }
        currentIndex: swipeView.currentIndex
    }
}
