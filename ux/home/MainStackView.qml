import QtQuick
import QtQuick.Controls
import "../Screens"

Item {
    id: root
    property alias mainStackView: mainStackView
    StackView {
        id: mainStackView
        anchors.fill: parent
        initialItem: HomeScreen {}
    }
}
