//DashboardToggle.qml - Toggle button for dashboard access

import QtQuick 2.12
import QtQuick.Controls 2.4
import QGroundControl.Controls 1.0

Rectangle {
    id: toggleButton
    width: 60
    height: 60
    radius: 30
    color: "#1a1d23"
    border.color: "#FFD700"
    border.width: 2
    
    property bool dashboardVisible: false
    signal toggleDashboard()
    
    // Gradient effect
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2a2d33" }
            GradientStop { position: 1.0; color: "#1a1d23" }
        }
    }
    
    Text {
        anchors.centerIn: parent
        text: dashboardVisible ? "✕" : "📊"
        font.pixelSize: 24
        color: "#FFD700"
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            dashboardVisible = !dashboardVisible
            toggleDashboard()
        }
    }
    
    // Hover effect
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "#FFD700"
        opacity: parent.children[2].pressed ? 0.2 : 0
        
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
}
