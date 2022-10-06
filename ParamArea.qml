import QtQuick 2.0
import QtQuick.Controls 1.1

Item
{
    id: container

    property alias name: title.text
    property alias paramText: paramfield.text
    property alias help: helpText.text
    property string helpSide: ""
    property alias input: paramfield
    width: 140;
    height: 25;

    TextField
    {
        id: paramfield

        width: parent.width;
        height: parent.height;
        placeholderText: qsTr("Dimensión en mm");
        validator: RegExpValidator{ regExp: /\d{1,7}([.]\d{1,3})+$/ }
    }

    Text
    {
        id: title;

        text: qsTr(name);
        anchors.right: paramfield.left;
        anchors.verticalCenter: paramfield.verticalCenter;
        anchors.rightMargin: 20;
    }

    Rectangle
    {
        id: helpZone;

        width: helpText.contentWidth;
        height: helpText.contentHeight;
        border.width: 1;
        color: "#fffaf0";
        anchors.margins: 20
        anchors.verticalCenter: (helpSide == "left" || "right") ? paramfield.verticalCenter : undefined
        anchors.horizontalCenter: (helpSide == "below" || "above") ? paramfield.horizontalCenter : undefined
        anchors.right: (helpSide == "left") ? paramfield.left : undefined
        anchors.left: (helpSide == "rigth") ? paramfield.right : undefined
        anchors.top: (helpSide == "below") ? paramfield.bottom : undefined
        anchors.bottom: (helpSide == "above") ? paramfield.top : undefined
        visible: paramfield.hovered;
        z: 100;

        Text
        {
            id: helpText;

            text: help;
            anchors.fill: parent;
        }
    }
}
