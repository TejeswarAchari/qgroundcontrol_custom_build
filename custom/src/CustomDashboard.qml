//Enhanced CustomDashboard.qml - Fixed Layout with Proper Space Management
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11
import QGroundControl 1.0
import QGroundControl.Controls 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.Vehicle 1.0

Item {
    id: dashboardRoot
    anchors.fill: parent
    
    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property bool isVisible: true
    property bool expandedView: false
    
    // Modern overlay container
    Rectangle {
        id: dashboardContainer
        anchors.fill: parent
        color: "transparent"
        visible: dashboardRoot.isVisible
        
        // Gradient background overlay
        Rectangle {
            id: backgroundOverlay
            anchors.fill: parent
            color: "#CC000000"
            opacity: 0.9
            
            MouseArea {
                anchors.fill: parent
                onClicked: dashboardRoot.isVisible = false
            }
        }
        
        // Main dashboard panel - REDUCED SIZE for better fit
        Rectangle {
            id: mainPanel
            width: Math.min(900, parent.width * 0.9)  // Reduced from 1000
            height: Math.min(600, parent.height * 0.85) // Reduced from 700
            anchors.centerIn: parent
            color: "#1a1d23"
            radius: 20
            border.color: "#FFD700"
            border.width: 2
            
            // Gradient overlay for modern look
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#2a2d33" }
                    GradientStop { position: 1.0; color: "#1a1d23" }
                }
            }
            
            // Header - REDUCED HEIGHT
            Rectangle {
                id: header
                height: 60  // Reduced from 70
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: "transparent"
                
                RowLayout {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 15  // Reduced margins
                    spacing: 10
                    
                    Image {
                        source: "qrc:/custom/img/custom_splash.png"
                        Layout.preferredWidth: 40  // Reduced from 50
                        Layout.preferredHeight: 40
                        fillMode: Image.PreserveAspectFit
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.log("Failed to load dashboard image")
                                visible = false
                            }
                        }
                    }
                    
                    Column {
                        Text {
                            text: "Flight Dashboard"  // Shortened title
                            font.pixelSize: 20  // Reduced from 24
                            font.bold: true
                            color: "#FFD700"
                        }
                        Text {
                            text: activeVehicle ? "Connected" : "No Vehicle"
                            font.pixelSize: 10  // Reduced from 12
                            color: activeVehicle ? "#90ee90" : "#ff6b6b"
                        }
                    }
                }
                
                // Expand/Collapse and Close buttons
                RowLayout {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 15
                    spacing: 10
                    
                    QGCButton {
                        width: 30  // Reduced from 35
                        height: 30
                        text: expandedView ? "📋" : "📊"
                        font.pixelSize: 14  // Reduced from 16
                        onClicked: expandedView = !expandedView
                    }
                    
                    QGCButton {
                        width: 30
                        height: 30
                        text: "✕"
                        font.pixelSize: 16  // Reduced from 18
                        onClicked: dashboardRoot.isVisible = false
                    }
                }
            }
            
            // Scrollable content area - IMPROVED SCROLLING
            ScrollView {
                id: scrollView
                anchors.top: header.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10  // Reduced margins
                
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn  // Always show scrollbar
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                clip: true
                
                // Make scrolling more responsive
                ScrollBar.vertical.interactive: true
                ScrollBar.vertical.size: Math.min(1.0, scrollView.height / contentHeight)
                
                ColumnLayout {
                    id: contentColumn
                    width: scrollView.width - 30  // Account for scrollbar
                    spacing: 12  // Reduced from 15
                    
                    // Primary Essential Indicators
                    Text {
                        text: "🎯 FLIGHT STATUS"
                        font.pixelSize: 16  // Reduced from 18
                        font.bold: true
                        color: "#FFD700"
                    }
                    
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 12  // Reduced spacing
                        columnSpacing: 12
                        
                        // Flight Mode & Armed Status - REDUCED HEIGHT
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100  // Reduced from 120
                            color: "#2b2f3a"
                            radius: 15
                            border.color: activeVehicle && activeVehicle.armed && activeVehicle.armed.value ? "#ff6b6b" : "#90ee90"
                            border.width: 2
                            
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 6  // Reduced spacing
                                
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 8
                                    
                                    Text {
                                        text: "✈️"
                                        font.pixelSize: 20  // Reduced from 24
                                    }
                                    Text {
                                        text: "Flight Mode"
                                        font.pixelSize: 16  // Reduced from 18
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                }
                                
                                Text {
                                    text: activeVehicle ? (activeVehicle.flightMode || "Unknown") : "Not Connected"
                                    color: "white"
                                    font.pixelSize: 14  // Reduced from 16
                                    font.bold: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                
                                Text {
                                    text: activeVehicle && activeVehicle.armed ? 
                                          (activeVehicle.armed.value ? "🔴 ARMED" : "🟢 DISARMED") : "Unknown Status"
                                    color: activeVehicle && activeVehicle.armed && activeVehicle.armed.value ? "#ff6b6b" : "#90ee90"
                                    font.pixelSize: 12  // Reduced from 14
                                    font.bold: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                        
                        // GPS Status - REDUCED HEIGHT
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100
                            color: "#2b2f3a"
                            radius: 15
                            border.color: activeVehicle && activeVehicle.gps && activeVehicle.gps.count && activeVehicle.gps.count.value >= 6 ? "#90ee90" : "#ff6b6b"
                            border.width: 2
                            
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 6
                                
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 8
                                    
                                    Text {
                                        text: "🛰️"
                                        font.pixelSize: 20
                                    }
                                    Text {
                                        text: "GPS Status"
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                }
                                
                                Text {
                                    text: activeVehicle && activeVehicle.gps && activeVehicle.gps.count ? 
                                          "Satellites: " + activeVehicle.gps.count.value : "No GPS Data"
                                    color: "white"
                                    font.pixelSize: 14
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                
                                Text {
                                    text: activeVehicle && activeVehicle.gps && activeVehicle.gps.hdop ? 
                                          "HDOP: " + activeVehicle.gps.hdop.value.toFixed(1) : "HDOP: N/A"
                                    color: "#cccccc"
                                    font.pixelSize: 10  // Reduced from 12
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                        

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            color: "#2b2f3a"
                            radius: 15
                            border.color: "#FFD700"
                            border.width: 2

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 6

                                Text {
                                    text: "🔋 Battery Status"
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#FFD700"
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                // Use Repeater exactly like official implementation
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 10

                                    Repeater {
                                        model: _activeVehicle ? _activeVehicle.batteries : 0

                                        RowLayout {
                                            spacing: 5

                                            property var battery: object

                                            // Battery percentage text using official logic
                                            Text {
                                                text: {
                                                    if (!isNaN(battery.percentRemaining.rawValue)) {
                                                        if (battery.percentRemaining.rawValue > 98.9) {
                                                            return "100%"
                                                        } else {
                                                            return battery.percentRemaining.valueString + battery.percentRemaining.units
                                                        }
                                                    } else if (!isNaN(battery.voltage.rawValue)) {
                                                        return battery.voltage.valueString + battery.voltage.units
                                                    } else if (battery.chargeState.rawValue !== 0) {
                                                        return battery.chargeState.enumStringValue
                                                    }
                                                    return "No Data"
                                                }
                                                font.pixelSize: 20
                                                font.bold: true
                                                color: {
                                                    switch (battery.chargeState.rawValue) {
                                                    case 0: return "white"      // OK
                                                    case 1: return "#ffa500"    // LOW
                                                    case 2:
                                                    case 3:
                                                    case 4:
                                                    case 5: return "#ff6b6b"    // CRITICAL/EMERGENCY/FAILED/UNHEALTHY
                                                    default: return "white"
                                                    }
                                                }
                                            }

                                            // Voltage display
                                            Text {
                                                text: !isNaN(battery.voltage.rawValue) ?
                                                      battery.voltage.valueString + battery.voltage.units : "N/A"
                                                color: "#cccccc"
                                                font.pixelSize: 10
                                            }
                                        }
                                    }

                                    // Fallback text when no batteries
                                    Text {
                                        text: "No Vehicle Connected"
                                        color: "#ff6b6b"
                                        font.pixelSize: 14
                                        visible: !_activeVehicle || !_activeVehicle.batteries || _activeVehicle.batteries.count === 0
                                    }
                                }
                            }
                        }

                        // Connection Status - REDUCED HEIGHT
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100
                            color: "#2b2f3a"
                            radius: 15
                            border.color: activeVehicle && activeVehicle.connectionLost !== undefined && !activeVehicle.connectionLost ? "#90ee90" : "#ff6b6b"
                            border.width: 2
                            
                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 6
                                
                                RowLayout {
                                    Layout.alignment: Qt.AlignHCenter
                                    spacing: 8
                                    
                                    Text {
                                        text: "📡"
                                        font.pixelSize: 20
                                    }
                                    Text {
                                        text: "Connection"
                                        font.pixelSize: 16
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                }
                                
                                Text {
                                    text: activeVehicle ? "Connected" : "Disconnected"
                                    color: activeVehicle ? "#90ee90" : "#ff6b6b"
                                    font.pixelSize: 14
                                    font.bold: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                
                                Text {
                                    text: "Signal: " + (activeVehicle ? "Strong" : "No Signal")
                                    color: "#cccccc"
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                    
                    // Navigation & Performance Section - COMPACT
                    Text {
                        text: "🧭 NAVIGATION & PERFORMANCE"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#FFD700"
                    }
                    
                    GridLayout {
                        Layout.fillWidth: true
                        columns: expandedView ? 3 : 2
                        rowSpacing: 12
                        columnSpacing: 12
                        
                        // Compact indicator cards - REDUCED HEIGHT
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80  // Reduced from 100
                            color: "#2b2f3a"
                            radius: 12
                            border.color: "#4a9eff"
                            border.width: 2
                            
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 10
                                
                                Text {
                                    text: "📏"
                                    font.pixelSize: 16  // Reduced from 20
                                }
                                
                                Column {
                                    Text {
                                        text: "Altitude"
                                        font.pixelSize: 12  // Reduced from 14
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                    Text {
                                        text: activeVehicle && activeVehicle.altitudeRelative ?
                                              activeVehicle.altitudeRelative.value.toFixed(1) + " m" : "N/A"
                                        color: "white"
                                        font.pixelSize: 14  // Reduced from 16
                                        font.bold: true
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            color: "#2b2f3a"
                            radius: 12
                            border.color: "#00bfff"
                            border.width: 2
                            
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 10
                                
                                Text {
                                    text: "🏃"
                                    font.pixelSize: 16
                                }
                                
                                Column {
                                    Text {
                                        text: "Ground Speed"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                    Text {
                                        text: activeVehicle && activeVehicle.groundSpeed ?
                                              activeVehicle.groundSpeed.value.toFixed(1) + " m/s" : "N/A"
                                        color: "white"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            color: "#2b2f3a"
                            radius: 12
                            border.color: "#32cd32"
                            border.width: 2
                            
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 10
                                
                                Text {
                                    text: "🏠"
                                    font.pixelSize: 16
                                }
                                
                                Column {
                                    Text {
                                        text: "Distance Home"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                    Text {
                                        text: activeVehicle && activeVehicle.distanceToHome ?
                                              activeVehicle.distanceToHome.value.toFixed(0) + " m" : "N/A"
                                        color: "white"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                }
                            }
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            color: "#2b2f3a"
                            radius: 12
                            border.color: "#ff6347"
                            border.width: 2
                            
                            RowLayout {
                                anchors.centerIn: parent
                                spacing: 10
                                
                                Text {
                                    text: "🧭"
                                    font.pixelSize: 16
                                }
                                
                                Column {
                                    Text {
                                        text: "Heading"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: "#FFD700"
                                    }
                                    Text {
                                        text: activeVehicle && activeVehicle.heading ?
                                              activeVehicle.heading.value.toFixed(0) + "°" : "N/A"
                                        color: "white"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                }
                            }
                        }
                    }
                    
                    // Mission Status Section - ONLY IN EXPANDED VIEW & COMPACT
                    Column {
                        Layout.fillWidth: true
                        visible: expandedView  // Only show when expanded
                        spacing: 8
                        
                        Text {
                            text: "🎯 MISSION STATUS"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#FFD700"
                        }
                        
                        // SINGLE ROW instead of grid to save space
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15
                            
                            Rectangle {
                                Layout.preferredWidth: 150  // Fixed width
                                Layout.preferredHeight: 60   // Much smaller height
                                color: "#2b2f3a"
                                radius: 8
                                border.color: "#ffd700"
                                border.width: 1
                                
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    
                                    Text {
                                        text: "📋"
                                        font.pixelSize: 14
                                    }
                                    
                                    Column {
                                        Text {
                                            text: "Mission"
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: "#FFD700"
                                        }
                                        Text {
                                            text: activeVehicle && activeVehicle.missionManager ? "Active" : "No Mission"
                                            color: "white"
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: 150
                                Layout.preferredHeight: 60
                                color: "#2b2f3a"
                                radius: 8
                                border.color: "#20b2aa"
                                border.width: 1
                                
                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    
                                    Text {
                                        text: "⏰"
                                        font.pixelSize: 14
                                    }
                                    
                                    Column {
                                        Text {
                                            text: "Flight Time"
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: "#FFD700"
                                        }
                                        Text {
                                            text: activeVehicle && activeVehicle.flightTime ?
                                                  Math.floor(activeVehicle.flightTime / 60) + ":" + 
                                                  String(activeVehicle.flightTime % 60).padStart(2, '0') : "00:00"
                                            color: "white"
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
