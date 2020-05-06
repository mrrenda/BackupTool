import QtQuick 2.0

Item {
    property var buttonColor: "red"
    property alias func: mouseArea

    Rectangle {
        color: buttonColor
        opacity: 0.5
        width: 10
        height: 10
        radius: this.width

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: parent.opacity = 1
            onExited: parent.opacity = 0.5
        }
    }
}
