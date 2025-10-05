import QtQuick 
import QtQuick.Shapes 


Item {
    id: progress
    implicitWidth: 200
    implicitHeight: 200

    // Properties
    // General
    property bool roundCap: true
    property int startAngle: -240
    property real maxValue: 83.33
    property real value: 3
    property int samples: 4
    // Bg Circle
    property color bgColor: "transparent"
    property color bgStrokeColor: "#7e7e7e"
    property int strokeBgWidth: 16
    // Progress Circle
    property color progressColor: "#55aaff"
    property int progressWidth: 16
    // Text
    property string text: "°C"
    property bool textShowValue: true
    property string textFontFamily: "Segoe UI"
    property int textSize: 12
    property color textColor: "#7c7c7c"


    Shape{
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: progress.samples

        ShapePath{
            id: pathBG
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: 300
            }
        }

        ShapePath{
            id: path
            strokeColor: progress.progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.startAngle
                sweepAngle: (300 / progress.maxValue * progress.value)
            }
        }

        Text {
            id: textProgress
            text: progress.textShowValue ? parseFloat(progress.value).toFixed(1) + progress.text : progress.text
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            color: progress.textColor
            font.pointSize: progress.textSize
            font.family: progress.textFontFamily
            font.bold: true
        }

        Image {
            id: temp
            width: 26
            height: width
            source: "qrc:/Assert/icons8-thermometer-100.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                bottom: textProgress.top
                horizontalCenter: textProgress.horizontalCenter
                bottomMargin: 5
            }
        }
    }
}


