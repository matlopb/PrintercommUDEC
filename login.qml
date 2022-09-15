import QtQuick 2.15
import QtQml 2.0
import QtQuick.Window 2.15
import QtCharts 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3


Window {
    id: login_dialog

    width: {
        if (Qt.platform.os == "linux"){
            730 * screenScaleFactor
        }
        else if (Qt.platform.os == "windows"){
            900 * screenScaleFactor
        }
        else if (Qt.platform.os == "osx"){
            900 * screenScaleFactor
        }
    }
    height: {
        if (Qt.platform.os == "linux"){
            590 * screenScaleFactor
        }
        else if (Qt.platform.os == "windows"){
            750 * screenScaleFactor
        }
        else if (Qt.platform.os == "osx"){
            750 * screenScaleFactor
        }
    }
    minimumHeight: {
        if (Qt.platform.os == "linux"){
            580 * screenScaleFactor
        }
        else if (Qt.platform.os == "windows"){
            750 * screenScaleFactor
        }
        else if (Qt.platform.os == "osx"){
            750 * screenScaleFactor
        }
    }
    minimumWidth: {
        if (Qt.platform.os == "linux"){
            730 * screenScaleFactor
        }
        else if (Qt.platform.os == "windows"){
            900 * screenScaleFactor
        }
        else if (Qt.platform.os == "osx"){
            900 * screenScaleFactor
        }
    }
    visible: true
    color: "#EBEBEB"
    title: qsTr("Connect to printer")
    property string plc_path: ""
    property var plc_info:["-----", "-----", "-----"]

    onClosing:{
        close.accepted = false
        monitoring_tab.item.stop_timer()
        close.accepted = true
    }

    TabView {
        id: frame
        height: parent.height - 50
        width: parent.width -50
        anchors.centerIn: parent

        style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? "ghostwhite" :"silver"
                    border.color:  "steelblue"
                    implicitWidth: login_dialog.width/3 - 33
                    implicitHeight: 20
                    radius: 2
                    Text {
                        id: text
                        anchors.centerIn: parent
                        text: styleData.title
                        color: styleData.selected ? "black" : "black"
                    }
                }
                frame: Rectangle { color: "steelblue" }
            }

        Tab {
            id: login_tab

            title: "Log to machine"
            Rectangle {
                width: frame.width
                height: frame.height

                ListModel{
                    id: plc_info_model

                    ListElement{
                        name: "Nombre del dispositivo"
                        value: "-----------"
                    }
                    ListElement{
                        name: "Nombre del controlador"
                        value: "-----------"
                    }
                    ListElement{
                        name: "Programas"
                        value: "-----------"
                    }
                }

                Component{
                    id: my_delegate

                    Rectangle{
                        border.width: 1
                        width: 300
                        height: childrenRect.height
                        color: "oldlace"
                        Text {
                            id: model_name
                            text: name + ": " + value
                        }
                    }
                }

                Text{
                    id: login_title

                    text: "Conecte a la impresora";
                    font.bold: true;
                    font.pointSize: 16;
                    font.pixelSize: 20;
                    anchors.top: parent.top;
                    anchors.topMargin: 20;
                    anchors.left: parent.left;
                    anchors.leftMargin: 40;
                }

                ColumnLayout{
                    id: main_column

                    spacing: 10
                    anchors.horizontalCenter: login_title.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    Text{
                        id: main_text

                        text: qsTr("Para realizar la conexion por favor indique \nla dirección IP del PLC de la impresora.")
                        wrapMode: main_text.WordWrap
                    }

                    Row{
                        id: content_Item

                        height: 30
                        Layout.preferredWidth: 200

                        Text{
                            id: field_Indicator

                            text: qsTr("Dirección IP: ")
                        }

                        TextField{
                            id: ip_field

                            width: 140
                            placeholderText: qsTr("e.g. 192.168.1.34/2");
                            text: qsTr("192.168.1.27/2");
                            validator: RegExpValidator{ regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\/(([0-6]|3([0])|2([0-9]))\.)$/}
                        }
                    }

                    Button{
                        id: login

                        text: qsTr("conectar")
                        onClicked: {
                            plc_path = ip_field.text
                            plc_info = manager.get_plc_info(plc_path)
                            plc_info_model.setProperty(0, "value", plc_info[0])
                            plc_info_model.setProperty(1, "value", plc_info[1])
                            plc_info_model.setProperty(2, "value", plc_info[2])
                            monitoring_tab.item.load_tags()
                        }
                    }

                    ListView{
                        model: plc_info_model
                        delegate: my_delegate
                        height: 200
                    }
                }

                Text{
                    id: params_title

                    text: "Parametros de la impresora";
                    font.bold: true;
                    font.pointSize: 16;
                    font.pixelSize: 20;
                    anchors.top: parent.top;
                    anchors.topMargin: 20;
                    anchors.right: parent.right;
                    anchors.rightMargin: 40;
                }

                ColumnLayout
                {
                    anchors.horizontalCenter: params_title.horizontalCenter
                    anchors.top: params_title.bottom;
                    anchors.topMargin: 20;
                    spacing: 10;
                    z:100

                    ParamArea{id: sb; paramText: "538"; name: "S_B"; help: " Es la distancia entre los actuadores del RDL "; helpSide: "left"}
                    ParamArea{id: sp; paramText: "108"; name: "s_p"; help: " Es la distancia entre los puntos de conexion \n del efector y los brazos del robot "; helpSide: "left"}
                    ParamArea{id: ub; paramText: "411"; name: "U_B"; help: " Es la distancia entre el actuador y el centro \n de la base "; helpSide: "left"}
                    ParamArea{id: up; paramText: "62"; name: "u_p"; help: " Es la distancia entre el punto de conexion y \n el centro del efector "; helpSide: "left"}
                    ParamArea{id: wb; paramText: "310"; name: "W_B"; help: " Es la distancia entre el centro de la base y \n el punto medio del tramo descrito por S_b "; helpSide: "left"}
                    ParamArea{id: wp; paramText: "31"; name: "w_p"; help: " Es la distancia entre el efector y el punto \n medio del tramo descrito por s_p "; helpSide: "left"}
                    ParamArea{id: armLen; paramText: "983"; name: "Largo de brazo"; help: " Es el largo de los brazos de la impresora "; helpSide: "left"}
                    ParamArea{id: printerH; paramText: "1460"; name: "Altura impresora"; help: " Es la distancia entre la base del RDL y la \n superficie de impresion "; helpSide: "left"}
                    ParamArea{id: radio; paramText: "225"; name: "Radio WS"; help: " Es el radio de la base del espacio de trabajo "; helpSide: "left"}
                    ParamArea{id: altura; paramText: "500"; name: "Altura WS"; help: " Es la altura del espacio de trabajo "; helpSide: "left"}
                }
            }
        }

        Tab {
            id: monitoring_tab

            title: "Monitoring"
            active: true
            enabled: true
            Rectangle {

                width: frame.width
                height: frame.height

                function load_tags(){my_combobox.model = manager.plc_tag_list(plc_path)}
                function stop_timer() {date_timer.running = false}

                ComboBox{
                    id: my_combobox

                    width: 200
                    editable: true
                    onActivated: {
                        date_timer.running = true
                        chart.series(0).name = currentText
                        chart.series(0).clear()
                    }
                }

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
                        id: time_axis

                        format: "hh:mm.ss"
                        min: new Date(new Date().getFullYear(), 1, 1, new Date().getHours(), new Date().getMinutes(), new Date().getSeconds())
                        max: new Date()
                        tickCount: 4
                    }

                }

                Component.onCompleted: {
                    console.log("Se ha iniciado QML\n")
                    var series1 = chart.createSeries(ChartView.SeriesTypeLine,"My grafico1",time_axis,axisY)
                }

                Timer{
                    id: date_timer
                    interval: 1000
                    running: false
                    repeat: true
                    onTriggered: {
                        var year = new Date().getFullYear()
                        var hours = new Date().getHours()
                        var minutes = new Date().getMinutes()
                        var seconds = new Date().getSeconds()
                        time_axis.min = new Date(year, 0, 0, hours, minutes - 1, seconds)
                        time_axis.max = new Date(year, 0, 0, hours, minutes, seconds)

                        var Y = manager.update_series(my_combobox.currentText, plc_path);
                        chart.series(0).append(time_axis.max, Y);
                    }
                }
            }
        }
        Tab {
            title: "3rd page"
            Rectangle {
                color: "green"
                width: frame.width
                height: frame.height}
        }
    }
}
