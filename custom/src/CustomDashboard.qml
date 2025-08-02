import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QGroundControl 1.0

Item {
    anchors.fill: parent
    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    Rectangle {
        anchors.fill: parent
        color: "#1c1f26"
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width

        ColumnLayout {
            anchors.margins: 20
            spacing: 20

            // Header with Logo
            RowLayout {
                spacing: 15
                Layout.alignment: Qt.AlignHCenter

                Image {
                    source: "qrc:/custom/img/indrones_dashboard_image.png"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 200
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Flight Dashboard"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#FFD700"
                }
            }

            // Connection Status Row
            Rectangle {
                color: "#2b2f3a"
                Layout.leftMargin: 100
                radius: 12
                Layout.fillWidth: true
                height: 60
                Row {
                    anchors.centerIn: parent
                    spacing: 30

                    Text {
                        text: activeVehicle ? "Connected" : "Not Connected"
                        font.pixelSize: 20
                        color: activeVehicle ? "#90ee90" : "#ff4d4d"
                    }

                    Text {
                        text: activeVehicle ? (activeVehicle.armed.value ? "Armed" : "Disarmed") : "--"
                        font.pixelSize: 20
                        color: activeVehicle && activeVehicle.armed.value ? "#90ee90" : "#ff4d4d"
                    }

                    Text {
                        text: activeVehicle ? ("Mode: " + (activeVehicle.flightMode || "Unknown")) : "--"
                        font.pixelSize: 20
                        color: "white"
                    }
                }
            }

            // Metrics Grid
            GridLayout {
                columns: 2
                rowSpacing: 15
                columnSpacing: 15
                Layout.fillWidth: true
                Layout.leftMargin: 100

                function safeText(condition, textIfTrue, fallback) {
                    return condition ? textIfTrue : fallback;
                }

                // GPS
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "GPS"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.gps.fixType && activeVehicle.gps.count
                                  ? "Fix: " + activeVehicle.gps.fixType.value + ", Sats: " + activeVehicle.gps.count.value
                                  : "N/A"
                            color: "white"
                        }
                    }
                }

                // Battery
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "Battery"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.battery.voltage && activeVehicle.battery.percentRemaining
                                  && !isNaN(activeVehicle.battery.voltage.value)
                                  ? activeVehicle.battery.voltage.value.toFixed(1) + "V | " + activeVehicle.battery.percentRemaining.value + "%"
                                  : "N/A"
                            color: "white"
                        }
                    }
                }

                // Altitude
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "Altitude"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.altitudeRelative
                                  ? activeVehicle.altitudeRelative.value.toFixed(1) + " m" : "N/A"
                            color: "white"
                        }
                    }
                }

                // Ground Speed
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "Ground Speed"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.groundSpeed
                                  ? activeVehicle.groundSpeed.value.toFixed(1) + " m/s" : "N/A"
                            color: "white"
                        }
                    }
                }

                // Heading
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "Heading"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.heading
                                  ? activeVehicle.heading.value.toFixed(0) + "°" : "N/A"
                            color: "white"
                        }
                    }
                }

                // RC Signal
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "RC Signal"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.rcRSSI && activeVehicle.rcRSSI.value !== undefined
                                  ? activeVehicle.rcRSSI.value + "%" : "No RC Data"
                            color: "white"
                        }
                    }
                }

                // Telemetry
                Rectangle {
                    width: 300; height: 90; radius: 10; color: "#2b2f3a"
                    Column { anchors.centerIn: parent
                        Text { text: "Telemetry"; color: "#FFD700"; font.bold: true }
                        Text {
                            text: activeVehicle && activeVehicle.telemetryRXErrors
                                  ? "Errors: " + activeVehicle.telemetryRXErrors.value : "No Telemetry Data"
                            color: "white"
                        }
                    }
                }
            }

            // Alerts
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 100
                height: 60
                radius: 8
                color: "#15171c"
                Text {
                    anchors.centerIn: parent
                    text: activeVehicle && activeVehicle.message && activeVehicle.message.count > 0
                          ? "Warning: " + activeVehicle.message.get(0).text
                          : "No Active Warnings"
                    font.pixelSize: 18
                    color: "#FFD700"
                }
            }
        }
    }
}
