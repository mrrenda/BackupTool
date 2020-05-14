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
    height: 400
    color: "#000000"

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

    Image {
        id: imageSettings
        x: 265
        y: 365
        width: 25
        height: 25
        fillMode: Image.PreserveAspectFit
        source: "img/settings.png"

        MouseArea {
            anchors.fill: parent
            onPressed: {
                popupSettings.open()
            }
        }

        Popup {
            id: popupSettings
            anchors.centerIn: parent
            width: 200
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
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
            coloredRing.circleProgressAngleDegree = core.workload * 360 / 100
        }
    }

    Label {
        id: lblStatus
        text: "Ready to backup"
        color: "gray"
        x: 10
        y: 10
    }

    ColoredRingButton {
        id: coloredRing
        anchors.centerIn: parent
        ringSize: 120
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

        Popup {
            id: popup
            anchors.centerIn: parent
            width: 300
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            Row {
                spacing: 20

                Label{
                    text: "Theme"
                    color: "gray"
                    x: 10
                    y: 10
                }

                ComboBox {
                    id: themeSelector
//                    x: 25
//                    y: 69
                    width: 80
                    height: 40
                    font.weight: Font.Light
                    font.pixelSize: 8
                    rightPadding: 0
                    font.family: "Arial"
                    flat: false
                    textRole: ""
                    currentIndex: 0
                    editable: false
                    model: [ "Dark", "Light" ]

                    onCurrentIndexChanged: {
                        if(currentIndex === 0) {
                            window.color = "#000000"
                        } else {
                            window.color = "#FAFAFA"
                            coloredRing.buttonColor = "#FAFAFA"
                        }
                    }
                }
            }
        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.5}
}
##^##*/
