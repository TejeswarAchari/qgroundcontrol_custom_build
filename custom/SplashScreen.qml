import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: splash
    color: "#1E1E1E"
    
    Column {
        anchors.centerIn: parent
        spacing: 20
        
        Image {
            source: "qrc:/custom/img/custom_splash.png"
            width: 150
            height: 150
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
            
            // Fallback if image not found
            Rectangle {
                visible: parent.status === Image.Error
                width: parent.width
                height: parent.height
                color: "#3A86FF"
                radius: 75
                
                Text {
                    anchors.centerIn: parent
                    text: "LOGO"
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true
                }
            }
        }
        
        Text {
            text: "Indrones QGroundControl"
            font.pixelSize: 24
            font.bold: true
            color: "#FFFFFF"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            text: "Loading..."
            font.pixelSize: 16
            color: "#CCCCCC"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        // Loading animation
        Rectangle {
            width: 200
            height: 4
            color: "#333333"
            radius: 2
            anchors.horizontalCenter: parent.horizontalCenter
            
            Rectangle {
                id: loadingBar
                height: parent.height
                color: "#3A86FF"
                radius: 2
                width: 0
                
                NumberAnimation on width {
                    from: 0
                    to: 200
                    duration: 3000
                    loops: 1
                }
            }
        }
    }
}
