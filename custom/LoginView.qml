import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import AuthManager 1.0

// Full-screen overlay that covers EVERYTHING including toolbar
Rectangle {
    id: authOverlay
    // This will be set by C++ code to match window size
    width: parent ? parent.width : 1200
    height: parent ? parent.height : 800
    // Ensure we're anchored properly to parent
    anchors.fill: parent
    color: "transparent" // Transparent base so we can control backgrounds per screen

    // Only visible during splash and login phases
    visible: AuthManager.showSplash || AuthManager.showLogin

    // Splash Screen - Shows first for 3 seconds
    Rectangle {
        id: splashScreen
        anchors.fill: parent
        color: "#1a1a1a"
        visible: AuthManager.showSplash

        Column {
            anchors.centerIn: parent
            spacing: 30

            Image {
                id: splashLogo
                source: "qrc:/custom/img/custom_splash.png"
                width: 300
                height: 300
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: "Indrones Flight Control"
                color: "#FFD700"
                font.pixelSize: 28
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Powered by QGroundControl"
                color: "#bdc3c7"
                font.pixelSize: 16
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Loading..."
                color: "#bdc3c7"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Loading animation
            Rectangle {
                width: 300
                height: 6
                color: "#333333"
                radius: 3
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    id: loadingBar
                    width: 0
                    height: parent.height
                    color: "#FFD700"
                    radius: 3

                    NumberAnimation on width {
                        from: 0
                        to: 300
                        duration: 3000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    // Add this connection block for field clearing
    Connections {
        target: authManager
        function onClearLoginFields() {
            usernameField.text = ""
            passwordField.text = ""
            errorText.visible = false
            usernameField.forceActiveFocus()
        }
    }

    // Login Screen - Two panel layout matching reference design
    Rectangle {
        id: loginScreen
        anchors.fill: parent
        color: "#000000"
        visible: AuthManager.showLogin

        // Block all background interactions
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressed: mouse.accepted = true
            onClicked: mouse.accepted = true
        }

        Row {
            anchors.fill: parent
            spacing: 0

            // Left Panel - Branding/Info Side (matches reference layout)
            Rectangle {
                id: leftPanel
                width: parent.width * 0.6
                height: parent.height
                color: "#1a1a1a"

                // Background pattern or accent
                Rectangle {
                    anchors.fill: parent
                    color: "#1a1a1a"
                    
                    // Subtle geometric pattern
                    Canvas {
                        anchors.fill: parent
                        opacity: 0.1
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.strokeStyle = "#FFD700"
                            ctx.lineWidth = 1
                            var spacing = 50
                            for (var i = 0; i < width/spacing; i++) {
                                ctx.beginPath()
                                ctx.moveTo(i * spacing, 0)
                                ctx.lineTo(i * spacing, height)
                                ctx.stroke()
                            }
                            for (var j = 0; j < height/spacing; j++) {
                                ctx.beginPath()
                                ctx.moveTo(0, j * spacing)
                                ctx.lineTo(width, j * spacing)
                                ctx.stroke()
                            }
                        }
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 40
                    width: parent.width * 0.8

                    // Company logo placeholder
                    Image {
                        id: companyLogo
                        source: "qrc:/custom/img/custom_splash.png"
                        width: 300
                        height: 300
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    // Main title
                    Text {
                        text: "Indrones Flight Control System"
                        color: "#FFD700"
                        font.pixelSize: 32
                        font.bold: true
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    // Subtitle
                    Text {
                        text: "Advanced UAV Mission Management Platform"
                        color: "#CCCCCC"
                        font.pixelSize: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }

                    // Feature highlights
                    Column {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 15

                        Row {
                            spacing: 15
                            Text {
                                text: "✓"
                                color: "#FFD700"
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                text: "Real-time flight monitoring"
                                color: "#999999"
                                font.pixelSize: 14
                            }
                        }

                        Row {
                            spacing: 15
                            Text {
                                text: "✓"
                                color: "#FFD700"
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                text: "Advanced mission planning"
                                color: "#999999"
                                font.pixelSize: 14
                            }
                        }

                        Row {
                            spacing: 15
                            Text {
                                text: "✓"
                                color: "#FFD700"
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                text: "Multi-drone fleet management"
                                color: "#999999"
                                font.pixelSize: 14
                            }
                        }
                    }
                }
            }

            // Right Panel - Login Form (matches reference layout)
            Rectangle {
                id: rightPanel
                width: parent.width * 0.4
                height: parent.height
                color: "#f5f5f5"

                Column {
                    anchors.centerIn: parent
                    width: Math.min(400, parent.width * 0.85)
                    spacing: 30

                    // Welcome text
                    Column {
                        width: parent.width
                        spacing: 10

                        Text {
                            text: "Welcome!"
                            color: "#1a1a1a"
                            font.pixelSize: 32
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Please login to your account"
                            color: "#666666"
                            font.pixelSize: 16
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Login form
                    Column {
                        width: parent.width
                        spacing: 20

                        // Username field
                        Column {
                            width: parent.width
                            spacing: 8

                            Text {
                                text: "Username"
                                color: "#333333"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            TextField {
                                id: usernameField
                                placeholderText: "operator / engineer"
                                width: parent.width
                                height: 50
                                font.pixelSize: 16
                                leftPadding: 15
                                rightPadding: 15

                                background: Rectangle {
                                    color: "white"
                                    border.color: usernameField.activeFocus ? "#FFD700" : "#CCCCCC"
                                    border.width: 2
                                    radius: 8
                                }
                                color: "#333333"
                                selectByMouse: true
                            }
                        }

                        // Password field
                        Column {
                            width: parent.width
                            spacing: 8

                            Text {
                                text: "Password"
                                color: "#333333"
                                font.pixelSize: 14
                                font.bold: true
                            }

                            TextField {
                                id: passwordField
                                placeholderText: "Enter your password"
                                width: parent.width
                                height: 50
                                font.pixelSize: 16
                                echoMode: TextInput.Password
                                leftPadding: 15
                                rightPadding: 15

                                background: Rectangle {
                                    color: "white"
                                    border.color: passwordField.activeFocus ? "#FFD700" : "#CCCCCC"
                                    border.width: 2
                                    radius: 8
                                }
                                color: "#333333"
                                selectByMouse: true
                                onAccepted: loginButton.clicked()
                            }
                        }

                        // Login button
                        Button {
                            id: loginButton
                            text: "Sign In"
                            width: parent.width
                            height: 50
                            font.pixelSize: 16
                            font.bold: true

                            background: Rectangle {
                                color: loginButton.pressed ? "#E6C200" : "#FFD700"
                                radius: 8
                                
                                Rectangle {
                                    anchors.fill: parent
                                    color: "transparent"
                                    border.color: "#E6C200"
                                    border.width: 1
                                    radius: 8
                                    visible: loginButton.hovered
                                }
                            }

                            contentItem: Text {
                                text: loginButton.text
                                font: loginButton.font
                                color: "#1a1a1a"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                console.log("Login attempt:", usernameField.text)
                                errorText.visible = false
                                
                                if (usernameField.text.trim() === "" || passwordField.text.trim() === "") {
                                    errorText.text = "Please enter both username and password"
                                    errorText.visible = true
                                    return
                                }

                                if (authManager && authManager.authenticate(usernameField.text.trim(), passwordField.text)) {
                                    console.log("Login successful!")
                                    usernameField.text = ""
                                    passwordField.text = ""
                                } else {
                                    errorText.text = "Invalid credentials. Use: operator/op123 or engineer/eng456"
                                    errorText.visible = true
                                    passwordField.text = ""
                                    usernameField.text = ""
                                    usernameField.forceActiveFocus()
                                }
                            }
                        }

                        // Error message
                        Text {
                            id: errorText
                            color: "#e74c3c"
                            font.pixelSize: 14
                            visible: false
                            wrapMode: Text.WordWrap
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                        }

                        // User info
                        Rectangle {
                            width: parent.width
                            height: 60
                            color: "#E8E8E8"
                            radius: 8
                            border.color: "#CCCCCC"
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: "👤 Operator: op123  |  🔧 Engineer: eng456"
                                color: "#666666"
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        // Exit button
                        Button {
                            text: "Exit Application"
                            width: parent.width
                            height: 40

                            background: Rectangle {
                                color: parent.pressed ? "#555555" : "transparent"
                                border.color: "#999999"
                                border.width: 1
                                radius: 8
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "#666666"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: Qt.quit()
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("LoginView overlay created with size:", width, "x", height)
        console.log("Parent:", parent)
    }
}













