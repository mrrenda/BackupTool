import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import com.renda.core 1.0

ApplicationWindow {
    property var state: 0
    property var progressText: "Ready"

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    id: window
    visible: true
    width: 500
    height: 200

    title: qsTr("core Tool")

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


    Column {
        id: column
        width: 434
        height: 62
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Label {
            id: lblStatus
            text: "Status"
        }

        ProgressBar {
            id: progressBar
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            value: 0.5
        }


        Button {
            id: button
            text: "Start"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter + 50
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
    }
}
