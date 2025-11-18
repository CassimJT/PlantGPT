pragma Singleton
import QtQuick
import QtQuick.Controls
import QtCore

QtObject {
    id: settings

    // General app settings
    property string appName: "PlantGPT"
    property string theme: "dark"
    property string apiUrl: "https://api.example.com"
    property string rtspUrl: "rtsp://192.168.8.117:8554/video"

    // UI customization
    property color primaryColor: "#6200EE"
    property color backgroundColor: "#121212"
    property int defaultPadding: 12

    // Utility function
    function toggleTheme() {
        theme = (theme === "dark") ? "light" : "dark"
    }
}
