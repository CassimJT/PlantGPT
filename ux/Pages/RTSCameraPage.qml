import QtQuick
import QtQuick.Controls
import QtMultimedia
import "../utils" as System

Page {
    id: videoPage
    signal stream()
    signal paused()
    property bool isStreaming: false
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
            fillMode: Image.PreserveAspectFit
        }
    }

    BusyIndicator {
        id: busyindicator
        running: player.playbackState !== MediaPlayer.PlayingState
        visible: running ? true : false
        anchors.centerIn: parent
    }

    Button {
        id: start
        text: isStreaming ? "Stop" : "Stream"
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 15
        }
        onClicked: {
            if(isStreaming) {
                player.stop()
                videoPage.isStreaming = false
                console.log("Stoped")
            }else {
                player.play()
                videoPage.isStreaming = true
                console.log("Playing")
            }
        }
    }
}
