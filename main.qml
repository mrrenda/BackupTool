import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import com.renda.core 1.0

ApplicationWindow {
    property var state: 0
    property var progressText: "Ready"

    flags: Qt.FramelessWindowHint
    title: qsTr("Baclup Tool")

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    id: window
    visible: true
    width: 300
    height: 200

    screen: Qt.application.screens[0]
    x: screen.width - this.width
    y: screen.height - this.height - 30

    MouseArea {
        property variant clickPos: "1,1"
        anchors.fill: parent

        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            window.x += delta.x;
            window.y += delta.y;
        }
    }

    Core {
        id: core
        onStarted:  { progressText = "Backing up.. " }
        onStopped:  { Qt.quit()                      }
        onPaused:   { progressText = "Paused "       }
        onResumed:  { progressText = "Backing up.. " }
        onProgress: {
            lblStatus.text = progressText + core.workload + "%"
            circleProgress.angleDegree = core.workload * 360 / 100
            circleProgress.requestPaint()
        }
    }

    Label {
        id: lblStatus
        text: "Ready to backup"
        color: "gray"
        x: 10
        y: 10
    }

    Canvas {
        property int radius: 65
        property int angleDegree: 0

        Behavior on angleDegree { SmoothedAnimation { velocity: 50 } }

        id: circleProgress
        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = width / 2;
            var centreY = height / 2 + 10;

            ctx.beginPath();
            ctx.fillStyle = "lightblue";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX,
                    centreY,
                    radius, - Math.PI / 2,
                    Math.PI * ((angleDegree / 180) - 0.5),
                    false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();
        }
    }

    Rectangle {
        id: button
        anchors.horizontalCenter: parent.horizontalCenter
        y: 50
        width: 120
        height: 120
        radius: width
        color: "#9C27B0"

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent
            onEntered: button.color = "#ce6ddf"
            onExited: button.color = "#9C27B0"

            onClicked: {
                if (state == 0) {
                    state = 1
                    buttonLbl.text = qsTr("Pause")
                    core.start()
                } else if (state == 1) {
                    state = 2
                    buttonLbl.text = qsTr("Resume")
                    core.pause()
                } else if (state == 2) {
                    state = 1
                    buttonLbl.text = qsTr("Pause")
                    core.resume()
                }
                console.log(state)
            }
        }

        Label {
            id: buttonLbl
            text: qsTr("Start")
            color: "black"
            anchors.centerIn: parent
        }
    }

    TitleBarButton {
        id: quitButton
        x: parent.width - (this.width + 20)
        y: 10
        buttonColor: "red"
        func.onPressed: { core.stop() }
    }

    TitleBarButton {
        id: settingsButton
        x: parent.width - (this.width + 35)
        y: 10
        buttonColor: "blue"
        func.onPressed: { popup.open() }
    }

    Popup {
        id: popup
        anchors.centerIn: parent
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }
}
