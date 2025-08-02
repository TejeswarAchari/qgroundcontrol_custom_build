import QtQuick 2.12

Rectangle {
    width: 500
    height: 300
    color: "black"

    Image {
        anchors.centerIn: parent
        source: "qrc:/custom/img/custom_splash.png"
        fillMode: Image.PreserveAspectFit
        width: 400
        height: 200
    }
}
