import QtQuick 2.15
import QtQuick.Controls 1.1
import QtQml 2.0
import QtQuick.Window 2.15
import QtQuick 2.0
import QtCharts 2.0

Window {
    id: loginDalog

    width: 900
    height: 900
    visible: true
    color: "#EBEBEB"
    title: qsTr("Connect to printer")
    property string plcPath: ""

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
                manager.save_value(ipField.text)
                plcPath = ipField.text
                dateTimer.running = true
            }
        }
    }

        /*TextField{
            id: valuefield

            width: 140
            placeholderText: qsTr("valor nuevo");
            validator: IntValidator
        }

        Button{
            id: update

            text: qsTr("update")
            onClicked: {
                manager.save_value(valuefield.text)
            }
        }*/

        ChartView {
            id: chart
            x: 180
            y: 90
            width: 500
            height: 300
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            ValueAxis{
                id: axisY
                min: 0
                max: 100
            }
            DateTimeAxis{
                id: timeAxis

                format: "hh:mm.ss"
                min: new Date(new Date().getFullYear(), 1, 1, new Date().getHours(), new Date().getMinutes(), new Date().getSeconds())
                max: new Date()
                tickCount: 4
            }

        }

        Component.onCompleted: {
            console.log("Se ha iniciado QML\n")
            var series1 = chart.createSeries(ChartView.SeriesTypeLine,"My grafico1",timeAxis,axisY)
        }    

    Timer{
        id: dateTimer
        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            var year = new Date().getFullYear()
            var hours = new Date().getHours()
            var minutes = new Date().getMinutes()
            var seconds = new Date().getSeconds()
            timeAxis.min = new Date(year, 0, 0, hours, minutes - 1, seconds)
            timeAxis.max = new Date(year, 0, 0, hours, minutes, seconds)

            manager.save_value(plcPath)
            var Y = manager.update_series();
            chart.series(0).append(timeAxis.max, Y);
        }
    }
}

