import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0

Item {
    property int ringSize: 120
    property int circleProgressAngleDegree: 0

    onCircleProgressAngleDegreeChanged: circleProgress.requestPaint()

    RectangularGlow {
        id: effect
        smooth: true
        anchors.fill: circleHolder
        glowRadius: 10
        spread: 0.9
        color: "#5555ff"
        cornerRadius: circleHolder.radius + glowRadius
        onColorChanged: circleProgress.requestPaint()

        SequentialAnimation {
            id: anim
            running: true
            loops: Animation.Infinite

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#55ff55"
                duration: 1000
            }

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#5555ff"
                duration: 1000
            }

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#ff5555"
                duration: 1000
            }

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#55ffff"
                duration: 1000
            }

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#ff55ff"
                duration: 1000
            }

            PropertyAnimation {
                targets: [ effect, circleHolder]
                property: "color"
                to: "#ffff55"
                duration: 1000
            }
        }
    }

    Rectangle {
        id: circleHolder
        color: "black"
        width: ringSize
        height: width
        radius: width / 2
        anchors.centerIn: parent

        Canvas {
            property int circleProgressRadius: ringSize / 2

            id: circleProgress
            width: circleHolder.width
            height: circleHolder.height
            anchors.fill: circleHolder
            anchors.centerIn: circleHolder
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();

                var centreX = width / 2;
                var centreY = height / 2;

                ctx.beginPath();
                ctx.fillStyle = "#FF0000"; //effect.color;
                ctx.moveTo(centreX, centreY);
                ctx.arc(centreX,
                        centreY,
                        circleProgressRadius, - Math.PI / 2,
                        Math.PI * ((circleProgressAngleDegree / 180) - 0.5),
                        false);
                ctx.lineTo(centreX, centreY);
                ctx.fill();
            }

            Rectangle {
                id: button
                anchors.centerIn: parent
                width: ringSize - 10
                height: width
                radius: width / 2
                color: "#000000"

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: button.color = "#303030"
                    onExited: button.color = "#000000"

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
//                        console.log(state)
                    }
                }

                Label {
                    id: buttonLbl
                    text: qsTr("Start")
                    color: "#FFFFFF"
                    anchors.centerIn: parent
                }
            }
        }
    }
}
