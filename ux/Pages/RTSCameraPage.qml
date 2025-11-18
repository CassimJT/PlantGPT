import QtQuick
import QtQuick.Controls
import QtMultimedia
import "../utils" as System

Page {
    id: videoPage
    Rectangle {
        id: screen
        color: "black"
        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            top: parent.top
        }
        MediaPlayer {
             id: player
             source: "rtsp://192.168.8.117:8554/video"
             videoOutput: videoOutput
            // autoPlay: true
        }
        VideoOutput {
            id: videoOutput
            anchors.fill: parent
        }
    }

    BusyIndicator {
        id: busyindicator
        running: player.playbackState !== MediaPlayer.PlayingState
        visible: running ? true : false
        anchors.centerIn: parent
    }

}
