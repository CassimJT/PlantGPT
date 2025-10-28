import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtCore
import "../utils"

Page {
    id: cameraPage
    objectName: "Camera"
    anchors.fill: parent
    property real btnSize: 70
    property bool isFrontCamera: false

    MediaDevices {
        id: mediaDevices
    }

    CaptureSession {
        id: captureSession
        camera: Camera {
            id: camera
            focusMode: Camera.FocusModeAuto
            onErrorChanged: {
                if (error !== Camera.NoError) {
                    console.log("Camera error:", errorString)
                }
            }
        }
        videoOutput: videoOutput
        imageCapture: ImageCapture {
            id: imageCapture
            fileFormat: ImageCapture.PNG
            quality: ImageCapture.NormalQuality
            onImageCaptured: function(requestId, preview) {
                console.log("Image preview captured")
                Helper.imageToDataUrl(preview)
                Helper.setIsHompage(true)
                camera.stop()
                mainLoader.item.mainStackView.pop()
            }
        }
    }

    Rectangle {
        id: videoOutputRec
        color: "black"
        visible: true
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: bottomBar.top
        }
        VideoOutput {
            id: videoOutput

            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
        }
    }

    Rectangle {
        id: bottomBar
        width: parent.width
        height: parent.height * 0.20
        color: "#333"

        RowLayout {
            anchors.centerIn: parent
            spacing: 20

            Rectangle {
                id: captureBtnFlame
                width: cameraPage.btnSize
                height: width
                radius: width / 2
                border.color: "white"
                border.width: 2
                color: Qt.rgba(0, 0, 0, 0)

                RoundButton {
                    id: captureBtn
                    width: parent.width * 0.8
                    height: width
                    anchors.centerIn: parent
                    icon.name: "camera"
                    icon.color: "white"
                    onClicked: {
                        if(imageCapture.readyForCapture) {
                             imageCapture.capture()
                        }
                    }
                }
            }
        }
        anchors {
            bottom: parent.bottom
        }
    }

    Component.onCompleted: {
        camera.start()
    }

    function backFrontCameraClicked() {
        var listOfCameras = mediaDevices.videoInputs
        if (camera.cameraDevice.position === CameraDevice.FrontFace) {
            for (var i = 0; i < listOfCameras.length; i++) {
                if (listOfCameras[i].position === CameraDevice.BackFace) {
                    camera.cameraDevice = listOfCameras[i]
                    return
                }
            }
        } else {
            for (var j = 0; j < listOfCameras.length; j++) {
                if (listOfCameras[j].position === CameraDevice.FrontFace) {
                    camera.cameraDevice = listOfCameras[j]
                    return
                }
            }
        }
    }
}
