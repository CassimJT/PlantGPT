import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    property int classNumber: 0
    ScrollView {
        id: scrollView
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            topMargin: parent.height * 0.10
        }

        clip: true

        Column {
            id: contentColumn
            width: scrollView.width
            spacing: 10
            padding: 20

            Text {
                id: diseaseText
                text: ModelRunner.diseaseName
                width: contentColumn.width - 40
                opacity: 0
                font.pixelSize: 20
                font.bold: true
                color: "#0078D4"
                Behavior on opacity { NumberAnimation { duration: 1000 } }
            }

            Text {
                id: descriptionText
                text: ModelRunner.description
                width: contentColumn.width - 40
                wrapMode: Text.WordWrap
                opacity: 0
                font.pixelSize: 16
                Behavior on opacity { NumberAnimation { duration: 1000 } }
            }

            Text {
                id: cureText
                text: ModelRunner.cure
                width: contentColumn.width - 40
                wrapMode: Text.WordWrap
                opacity: 0
                font.pixelSize: 16
                color: "#28A745"
                Behavior on opacity { NumberAnimation { duration: 1000 } }
            }
        }
    }

    SequentialAnimation {
        id: fadeInAnim
        running: false
        PropertyAnimation {
            target: diseaseText;
            property: "opacity";
            to: 1;
            duration: 1000
        }
        PauseAnimation {
            duration: 500
        }
        PropertyAnimation {
            target: descriptionText;
            property: "opacity";
            to: 1;
            duration:
                1000
        }
        PauseAnimation {
            duration: 500
        }
        PropertyAnimation {
            target: cureText;
            property: "opacity";
            to: 1;
            duration: 1000
        }
    }

    Component.onCompleted:{

    }
}
