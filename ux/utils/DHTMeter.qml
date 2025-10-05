import QtQuick
import QtQuick.Shapes


Item {
    id: progress
    implicitWidth: 200
    implicitHeight: 200

    // Properties
    // General
    property bool roundCap: true
    property int startAngle: -260
    property int sweepAngle: 160
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

    //the righthalf property
    property int rightStartAngle: -80
    property int rightSweepAngle: 160

    Shape{
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: progress.samples
        //the right half
        ShapePath{
            id: lefHalf
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
                sweepAngle: progress.sweepAngle
            }
        }
        //the left halp
        ShapePath{
            id: rightHalf
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.rightStartAngle
                sweepAngle: progress.rightSweepAngle
            }
        }
        //nthe left path fill
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

        //the right path fill
        ShapePath{
            id: rightfill
            strokeColor: progress.progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.rightStartAngle
                sweepAngle: (300 / progress.maxValue * progress.value)
            }
        }

    }
}


