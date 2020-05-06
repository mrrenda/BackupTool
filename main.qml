import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import com.renda.core 1.0

ApplicationWindow {
    property var state: 0
    property var progressText: "Ready"
    flags: Qt.FramelessWindowHint

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    id: window
    visible: true
    width: 500
    height: 200

    title: qsTr("Baclup Tool")

    Component.onCompleted: {
        progressBar.value = core.workload
    }

    Core {
        id: core
        onStarted: {
            progressText = "Backing up.. "
        }

        onStopped:  {
            progressBar.value = 0.0
        }

        onPaused: {
            progressText = "Paused "
        }

        onResumed: {
            progressText = "Backing up.. "
        }

        onProgress: {
            lblStatus.text = progressText + core.workload + "%"
            progressBar.value = (core.workload * 0.01)
        }
    }

    Label {
        id: lblStatus
        text: "Status"
        color: "gray"
        x: 10
        y: parent.height - 45
    }

    Label {
        id: lblTitle
        text: "Backup Tool"
        color: "gray"
        x: 10
        y: 10
    }

    ProgressBar {
        y: parent.height - 20
        id: progressBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        value: 0.5
    }


    Button {
        id: button
        text: "Start"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Material.accent: Material.Orange

        onClicked: {
            if (state == 0) {
                state = 1
                this.text = qsTr("Pause")
                core.start()
            } else if (state == 1) {
                state = 2
                this.text = qsTr("Resume")
                core.pause()
            } else if (state == 2) {
                state = 1
                this.text = qsTr("Pause")
                core.resume()
            }
            console.log(state)
        }
    }

    Rectangle {
        id: quitButton
        color: "red"
        opacity: 0.5
        width: 10
        height: 10
        radius: this.width
        x: parent.width - (this.width + 10)
        y: 10

        MouseArea {
            hoverEnabled: true
            anchors.fill: parent

            onEntered: parent.opacity = 1
            onExited: parent.opacity = 0.5
            onClicked: Qt.quit()
        }

    }
}
