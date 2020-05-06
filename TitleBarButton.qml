import QtQuick 2.0

Item {
        property var buttonColor: "red"
        function onclickFunc() {}

    Rectangle {
        color: buttonColor
        opacity: 0.5
        width: 10
        height: 10
        radius: this.width

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: parent.opacity = 1
            onExited: parent.opacity = 0.5
            onClicked: onclickFunc()
        }
    }
}
