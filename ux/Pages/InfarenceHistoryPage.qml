import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HistoryModel

Page {
    property int classIndex: 0
    property string diseaseName: ""
    property int timeDuration: 500
    property int pauseDuration: 200

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
                text: diseaseName
                width: contentColumn.width - 40
                opacity: 0
                font.pixelSize: 20
                font.bold: true
                color: "#0078D4"
                Behavior on opacity { NumberAnimation { duration: timeDuration } }
            }

            Text {
                id: descriptionText
                text: ModelRunner.description
                width: contentColumn.width - 40
                wrapMode: Text.WordWrap
                opacity: 0
                font.pixelSize: 16
                Behavior on opacity { NumberAnimation { duration: timeDuration } }
            }

            Text {
                id: cureText
                text: ModelRunner.cure
                width: contentColumn.width - 40
                wrapMode: Text.WordWrap
                opacity: 0
                font.pixelSize: 16
                color: "#28A745"
                Behavior on opacity { NumberAnimation { duration: timeDuration } }
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
            duration: timeDuration
        }
        PauseAnimation {
            duration: pauseDuration
        }
        PropertyAnimation {
            target: descriptionText;
            property: "opacity";
            to: 1;
            duration: timeDuration

        }
        PauseAnimation {
            duration: pauseDuration
        }
        PropertyAnimation {
            target: cureText;
            property: "opacity";
            to: 1;
            duration: timeDuration
        }
    }

    Component.onCompleted:{
        let description = ModelRunner.classDescripion(classIndex)
        let cure = ModelRunner.classCure(classIndex)
        descriptionText.text = description
        cureText.text = cure
        fadeInAnim.start()
    }
}
