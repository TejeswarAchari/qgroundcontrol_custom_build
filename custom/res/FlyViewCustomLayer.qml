/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import QtLocation 5.3
import QtPositioning 5.3
import QtQuick.Window 2.2
import QtQml.Models 2.1

import QGroundControl 1.0
import QGroundControl.Controllers 1.0
import QGroundControl.Controls 1.0
import QGroundControl.FactSystem 1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap 1.0
import QGroundControl.Palette 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Vehicle 1.0

Item {
    id: _root
    
    property var parentToolInsets
    property var totalToolInsets: _toolInsets
    property var mapControl
    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    // Pass through the parent insets with adjustments for our custom elements
    QGCToolInsets {
        id: _toolInsets
        leftEdgeTopInset: parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset: parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset: parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset: parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset: parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset: parentToolInsets.rightEdgeBottomInset + 80  // Add space for dashboard toggle at bottom
        topEdgeLeftInset: parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset: parentToolInsets.topEdgeCenterInset
        topEdgeRightInset: parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset: parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset: parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset: parentToolInsets.bottomEdgeRightInset + 80  // Add space for dashboard toggle
    }

    // Dashboard Toggle Button - Positioned like chatbase.co (bottom-right)
    Rectangle {
        id: dashboardToggle
        width: 70
        height: 70
        radius: 35
        color: "#1a1d23"
        border.color: "#FFD700"
        border.width: 2
        
        // Position in bottom-right corner like chat widgets
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 25
        z: 1000  // Ensure it's on top
        
        property bool dashboardVisible: false
        
        // Enhanced gradient for more modern look
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#3a3d43" }
                GradientStop { position: 0.5; color: "#2a2d33" }
                GradientStop { position: 1.0; color: "#1a1d23" }
            }
        }
        
        // Add shadow effect for depth
        Rectangle {
            width: parent.width + 4
            height: parent.height + 4
            radius: parent.radius + 2
            color: "#000000"
            opacity: 0.3
            anchors.centerIn: parent
            z: -1
        }
        
        Text {
            anchors.centerIn: parent
            text: dashboardToggle.dashboardVisible ? "✕" : "📊"
            font.pixelSize: 28
            color: "#FFD700"
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Dashboard toggle clicked") // Debug output
                dashboardToggle.dashboardVisible = !dashboardToggle.dashboardVisible
                dashboardLoader.active = dashboardToggle.dashboardVisible
            }
            
            // Add scaling animation on press
            onPressed: {
                scaleAnimation.running = true
            }
            
            onReleased: {
                scaleBackAnimation.running = true
            }
        }
        
        // Hover/press effects for better UX
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "#FFD700"
            opacity: parent.children[3].pressed ? 0.3 : (parent.children[3].containsMouse ? 0.1 : 0)
            
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }
        
        // Scale animations for press feedback
        NumberAnimation {
            id: scaleAnimation
            target: dashboardToggle
            property: "scale"
            from: 1.0
            to: 0.95
            duration: 100
        }
        
        NumberAnimation {
            id: scaleBackAnimation
            target: dashboardToggle
            property: "scale"
            from: 0.95
            to: 1.0
            duration: 100
        }
        
        // Subtle pulse animation when active
        SequentialAnimation {
            running: dashboardToggle.dashboardVisible
            loops: Animation.Infinite
            
            PropertyAnimation {
                target: dashboardToggle
                property: "border.width"
                from: 2
                to: 3
                duration: 1000
            }
            
            PropertyAnimation {
                target: dashboardToggle
                property: "border.width"
                from: 3
                to: 2
                duration: 1000
            }
        }
    }

    // Dashboard Loader - Safer approach than direct instantiation
    Loader {
        id: dashboardLoader
        anchors.fill: parent
        source: dashboardToggle.dashboardVisible ? "qrc:/custom/CustomDashboard.qml" : ""
        active: false
        z: 999
        
        onLoaded: {
            console.log("Dashboard loaded successfully") // Debug output
            if (item) {
                item.isVisible = Qt.binding(function() { return dashboardToggle.dashboardVisible })
                // Connect the dashboard's close signal back to toggle
                if (item.isVisibleChanged) {
                    item.isVisibleChanged.connect(function() {
                        if (!item.isVisible) {
                            dashboardToggle.dashboardVisible = false
                            dashboardLoader.active = false
                        }
                    })
                }
            }
        }
        
        onStatusChanged: {
            if (status === Loader.Error) {
                console.log("Error loading CustomDashboard.qml")
            }
        }
    }
    
    // Optional: Status indicator (small dot) when dashboard is available
    // Rectangle {
    //     width: 12
    //     height: 12
    //     radius: 6
    //     color: activeVehicle ? "#90ee90" : "#ff6b6b"
    //     border.color: "white"
    //     border.width: 1
        
    //     anchors.right: dashboardToggle.right
    //     anchors.top: dashboardToggle.top
    //     anchors.margins: -2
    //     z: 1001
        
    //     opacity: activeVehicle ? 0.9 : 0.6
        
    //     // Blinking animation when no vehicle connected
    //     SequentialAnimation {
    //         running: !activeVehicle
    //         loops: Animation.Infinite
            
    //         PropertyAnimation {
    //             target: parent
    //             property: "opacity"
    //             from: 0.6
    //             to: 0.2
    //             duration: 800
    //         }
            
    //         PropertyAnimation {
    //             target: parent
    //             property: "opacity"
    //             from: 0.2
    //             to: 0.6
    //             duration: 800
    //         }
    //     }
    // }
}
