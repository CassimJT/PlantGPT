import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls


Item {
    id: progress
    implicitWidth: 200
    implicitHeight: 200

    // Properties
    // General
    property bool roundCap: true
    property int progressWidth: 16
    property int samples: 4
    property bool textShowValue: true
    property string textFontFamily: "Segoe UI"
    property int textSize: 12
    property color textColor: "#7c7c7c"
    // Bg Circle
    property color bgColor: "transparent"
    property color bgStrokeColor: "#7e7e7e"
    property int strokeBgWidth: 16
    // Progress Circle
    property color t_progressColor: "#55aaff"
    property color h_progressColor: "#f50057"

    //
    property bool isTempCritical: false

    // Text
    property string t_unit: "°C"
    property string h_unit: "%"

    //progress start & end
    property int h_startAngle: -80
    property int h_sweepAngle: 160
    property int t_startAngle: -260
    property int t_sweepAngle: 160

    //maximum progress
    property real t_maxValue: 83.33
    property real h_maxValue: 100

    //progress values
    property real t_value: 30
    property real h_value: 50

    //Images
    property real iconSize: 32

    //imageIcons
    property color stateLableColor: "Cyan"
    property color valuesLableColor: "Gray"
    property real valuesLableSize: 12

    //dotted line
    Canvas {
        id: outerDotted
        anchors.centerIn: parent
        opacity: 0.4
        width: parent.width + 2 * (progress.strokeBgWidth + 4)
        height: parent.height + 2 * (progress.strokeBgWidth + 4)
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)
            var cx = width / 2
            var cy = height / 2
            var gauge_r = Math.min(parent.width, parent.height) / 2
            var r = gauge_r + progress.strokeBgWidth + 2
            var dots = 40
            ctx.fillStyle = "#555"
            for (var i = 0; i < dots; i++) {
                var ang = (i / dots) * Math.PI * 2
                var x = cx + Math.cos(ang) * r
                var y = cy + Math.sin(ang) * r
                ctx.beginPath()
                ctx.arc(x, y, 2, 0, Math.PI * 2)
                ctx.fill()
            }
        }
    }
    Shape{
        id: shape
        anchors.fill: parent
        layer.enabled: true
        layer.samples: progress.samples
        //temperature
        ShapePath{
            id: temperature
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.t_startAngle
                sweepAngle: progress.t_sweepAngle
            }
        }
        //humidity
        ShapePath{
            id: humidity
            strokeColor: progress.bgStrokeColor
            fillColor: progress.bgColor
            strokeWidth: progress.strokeBgWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.h_startAngle
                sweepAngle: progress.h_sweepAngle
            }
        }
        //temperature fill
        ShapePath{
            id: temperatureFill
            strokeColor: progress.t_progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc{
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: progress.t_startAngle
                sweepAngle: (progress.t_sweepAngle / progress.t_maxValue * progress.t_value)
            }
        }


        // humidity fill
        ShapePath {
            id: humidityFill
            strokeColor: progress.h_progressColor
            fillColor: "transparent"
            strokeWidth: progress.progressWidth
            capStyle: progress.roundCap ? ShapePath.RoundCap : ShapePath.FlatCap

            PathAngleArc {
                radiusX: (progress.width / 2) - (progress.progressWidth / 2)
                radiusY: (progress.height / 2) - (progress.progressWidth / 2)
                centerX: progress.width / 2
                centerY: progress.height / 2
                startAngle: -(progress.h_startAngle)
                sweepAngle: -(progress.h_sweepAngle / progress.h_maxValue * progress.h_value)
            }
        }
        //waring image
        Image {
            id: warning
            width: 52
            height: 52
            visible: isTempCritical
            source: "qrc:/assets/com/warning.png"
            fillMode: Image.PreserveAspectFit
            anchors {
                bottom: rowLayout.top
                horizontalCenter: rowLayout.horizontalCenter
            }
        }
        //imageIcons
        RowLayout {
            id:rowLayout
            anchors.centerIn: parent
            spacing: 8
            //temp
            ColumnLayout{
                spacing: 10
                Image {
                    id: tempImage
                    Layout.preferredWidth:  progress.iconSize
                    Layout.preferredHeight:  progress.iconSize
                    source: "qrc:/assets/com/temperature.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                }
                Label{
                    id: tempValue
                    text: progress.t_value + t_unit
                    font.pointSize: progress.valuesLableSize
                    color: progress.valuesLableColor
                    Layout.alignment: Qt.AlignHCenter
                }

            }
            Label{
                id: state
                text: "OFF"
                font.pointSize: 19
                font.bold: true
                color: progress.stateLableColor
            }
            //humidity
            ColumnLayout{
                spacing: 10
                Image {
                    id: humImage
                    Layout.preferredWidth:  progress.iconSize
                    Layout.preferredHeight:  progress.iconSize
                    source: "qrc:/assets/com/ihumidity_e.png"
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignHCenter
                }
                Label{
                    id: humValue
                    text: progress.h_value + h_unit
                    font.pointSize: progress.valuesLableSize
                    color: progress.valuesLableColor
                    Layout.alignment: Qt.AlignHCenter
                }
            }

        }
        Label {
            text: "Heating"
            visible: t_value > 40
            anchors {
                top: rowLayout.bottom
                topMargin: 10
                horizontalCenter: rowLayout.horizontalCenter
            }
        }


    }

    Timer{
        id:timer
        running: true
        interval: 1000
        repeat: true
        onTriggered: {
           if(t_value > 40) {
                isTempCritical = !isTempCritical
           }else {
               isTempCritical = false
           }
        }
    }
}


