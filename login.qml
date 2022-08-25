import QtQuick 2.15
import QtQuick.Controls 1.1
import QtQml 2.0
import QtQuick.Window 2.15
import QtQuick 2.0

Window {
    id: loginDalog

    width: 300
    height: 150
    visible: true
    color: "#EBEBEB"
    title: qsTr("Connect to printer")

    Column{
        id: mainColumn

        spacing: 10
        anchors.centerIn: parent
        width: 300
        height: parent.height

        Text{
            id: mainText

            text: qsTr("Indique la dirección IP del PLC de la impresora.")
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: mainText.WordWrap
        }

        Row{
            id: contentItem

            height: 100
            anchors.horizontalCenter: parent.horizontalCenter


            Text{
                id: fieldIndicator

                text: qsTr("Dirección IP: ")
            }

            TextField{
                id: ipField

                width: 140
                placeholderText: qsTr("e.g. 192.168.1.34/2");
                validator: RegExpValidator{ regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\/(([0-6]|3([0])|2([0-9]))\.)$/}
            }
        }

        Button{
            id: login

            text: qsTr("conectar")
            onClicked: {
                //manager.connect(ipField.text)
                plcInfo.text = manager.get_plc_info(ipField.text)
            }
        }

        TextArea
        {
            id: plcInfo;

            readOnly: true;
            width: parent.width;
            height: 300;
            wrapMode: TextArea.WorldWrap;
        }


    }

}
