import QtQuick 2.0
import QtQuick.Controls 1.1

Item
{
    id: container

    property alias name: title.text
    property alias paramText: paramfield.text
    property alias help: helpText.text
    width: 140;
    height: 25;

    TextField
    {
        id: paramfield

        width: parent.width;
        height: parent.height;
        placeholderText: qsTr("Dimensión en mm");
        validator: RegExpValidator{ regExp: /\d{1,7}([.]\d{1,3})+$/ }

        Text
        {
            id: title;

            text: qsTr(name);
            anchors.right: parent.left;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.rightMargin: 20;
        }

        Rectangle
        {
            id: helpZone;

            width: helpText.contentWidth;
            height: helpText.contentHeight;
            border.width: 1;
            color: "#fffaf0";
            anchors.left: parent.right;
            anchors.leftMargin: 20;
            anchors.verticalCenter: parent.verticalCenter;
            visible: parent.hovered;
            z: 100;

            Text
            {
                id: helpText;

                text: help;
                anchors.fill: parent;
            }
        }
    }

}
