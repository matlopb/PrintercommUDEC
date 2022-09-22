import QtQuick 2.15
import QtQml 2.0
import QtQuick.Window 2.15
import QtCharts 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3


Window {
    id: login_dialog

    visible: true
    color: "#EBEBEB"
    title: qsTr("Connect to printer")
    property string plc_path: ""
    property var plc_info:["-----", "-----", "-----"]
    property bool tagbox1_active: false
    property bool tagbox2_active: false
    property bool tagbox3_active: false
    property bool tagbox4_active: false

    width: {
        if (Qt.platform.os == "linux"){
            900 * screenScaleFactor
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

    Component.onCompleted: {
            x = Screen.width / 2 - width / 2
            y = Screen.height / 2 - height / 2

            if (manager.look_for_gcode() == false){
                login_tab.item.notify_gcode_status()
            }
        }

    Connections {
        target: manager

        function onProgressEnd() {
            win.close()
            var mDialog = Qt.createComponent("MessageDialog.qml");
            win = mDialog.createObject(login_dialog)
            win.show()
        }
    }

    onClosing:{
        close.accepted = false
        monitoring_tab.item.stop_timer()
        close.accepted = true
    }

    Button{
        id: send_instructions

        width: 200;
        height: 30;
        enabled: true
        anchors.right: parent.right
        anchors.rightMargin: 25;
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked:{
            manager.send_instructions()
        }

        style: ButtonStyle
        {
            label: Image
            {
                id: writeImage;
                source: "./images/write.png";
                fillMode: Image.PreserveAspectFit;
                horizontalAlignment: Image.AlignLeft;
            }
        }

        Text
        {
            text: qsTr("Enviar instrucciones")
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    TabView {
        id: frame
        height: parent.height - 50
        width: parent.width -50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        style: TabViewStyle {
                frameOverlap: 1
                tab: Rectangle {
                    color: styleData.selected ? "ghostwhite" :"silver"
                    border.color:  "steelblue"
                    implicitWidth: (login_dialog.width-48)/3
                    implicitHeight: 30
                    radius: 2
                    Text {
                        id: text
                        font.bold: true
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
            active: true
            enabled: true

            Rectangle {
                width: frame.width
                height: frame.height
                border.width: 1

                function notify_gcode_status(){
                    instructions_status_text.text = qsTr("No existe Gcode en el sistema. \nRebane una figura antes de conectar a una impresora")
                    //login_button.enabled = false
                    //generate_instructions.enabled = false
                }

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
                    anchors.leftMargin: 100;
                }

                ColumnLayout{
                    id: main_column

                    spacing: 30
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
                        id: login_button

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
                    anchors.rightMargin: 100;
                }

                ColumnLayout
                {
                    anchors.horizontalCenter: params_title.horizontalCenter
                    anchors.top: params_title.bottom;
                    anchors.topMargin: 20;
                    Layout.preferredWidth: frame.width/2
                    Layout.preferredHeight: frame.height
                    spacing: 10;
                    z:100

                    Text{
                        id: params_subtitle

                        Layout.preferredWidth: params_title.width
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Para generar las instrucciones indique los \nparametros de la impresora")
                    }

                    ParamArea{id: sb; paramText: "538"; name: "S_B"; help: " Es la distancia entre los actuadores del RDL "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: sp; paramText: "108"; name: "s_p"; help: " Es la distancia entre los puntos de conexion \n del efector y los brazos del robot "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: ub; paramText: "411"; name: "U_B"; help: " Es la distancia entre el actuador y el centro \n de la base "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: up; paramText: "62"; name: "u_p"; help: " Es la distancia entre el punto de conexion y \n el centro del efector "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: wb; paramText: "310"; name: "W_B"; help: " Es la distancia entre el centro de la base y \n el punto medio del tramo descrito por S_b "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: wp; paramText: "31"; name: "w_p"; help: " Es la distancia entre el efector y el punto \n medio del tramo descrito por s_p "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: armLen; paramText: "983"; name: "Largo de brazo"; help: " Es el largo de los brazos de la impresora "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: printerH; paramText: "1460"; name: "Altura impresora"; help: " Es la distancia entre la base del RDL y la \n superficie de impresion "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: radio; paramText: "225"; name: "Radio WS"; help: " Es el radio de la base del espacio de trabajo "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}
                    ParamArea{id: altura; paramText: "500"; name: "Altura WS"; help: " Es la altura del espacio de trabajo "; helpSide: "left"; Layout.alignment: Qt.AlignHCenter}

                    Rectangle{
                        id: instructions_status

                        Layout.preferredWidth: frame.width/3
                        Layout.preferredHeight: 50
                        Layout.alignment: Qt.AlignHCenter
                        border.width: 1

                        Text{
                            id: instructions_status_text

                            height: parent.height
                            width: parent.width
                            text: qsTr("No existen instrucciones en memeoria")
                        }
                    }

                    Button{
                        id: generate_instructions

                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 50
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Generar \n instrucciones")
                        onClicked: {
                            manager.generate_instructions_list(sb.paramText, sp.paramText, wb.paramText, wp.paramText, ub.paramText, up.paramText, armLen.paramText,
                                                               printerH.paramText, radio.paramText, altura.paramText)
                        }
                    }
                }
            }
        }

        Tab {
            id: monitoring_tab

            title: "Monitoreo"
            active: true
            enabled: true
            Rectangle {

                width: frame.width
                height: frame.height
                border.width: 1

                function load_tags(){
                    var tag_list = ["Seleccione un tag..."]
                    var get_list = manager.plc_tag_list(plc_path)
                    for(let element in get_list){
                        tag_list.push(get_list[element])
                    }
                    tagbox_1.model = tag_list
                    tagbox_2.model = tag_list
                    tagbox_3.model = tag_list
                    tagbox_4.model = tag_list
                }
                function stop_timer() {date_timer.running = false}

                Text{
                    id: tab_title

                    text: "Monitoreo de variables"
                    font.bold: true;
                    font.pointSize: 16;
                    font.pixelSize: 20;
                    anchors.top: parent.top;
                    anchors.topMargin: 20;
                    anchors.horizontalCenter: parent.horizontalCenter

                }

                ColumnLayout{
                    id: combobox_column

                    spacing: 20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -200

                    ComboBox{
                        id: tagbox_1

                        width: 400
                        editable: true
                        onActivated: {
                            date_timer.running = true
                            tagbox1_active = true
                            chart.series(0).name = currentText
                            chart.series(0).clear()
                        }
                    }

                    ComboBox{
                        id: tagbox_2

                        width: 400
                        editable: true
                        onActivated: {
                            date_timer.running = true
                            tagbox2_active = true
                            chart.series(1).name = currentText
                            chart.series(1).clear()
                        }
                    }

                    ComboBox{
                        id: tagbox_3

                        width: 400
                        editable: true
                        onActivated: {
                            date_timer.running = true
                            tagbox3_active = true
                            chart.series(2).name = currentText
                            chart.series(2).clear()
                        }
                    }

                    ComboBox{
                        id: tagbox_4

                        width: 400
                        editable: true
                        onActivated: {
                            date_timer.running = true
                            tagbox4_active = true
                            chart.series(3).name = currentText
                            chart.series(3).clear()
                        }
                    }

                }



                ChartView {
                    id: chart
                    x: 180
                    y: 90
                    width: 500
                    height: 300
                    anchors.left: combobox_column.right
                    anchors.leftMargin: 30
                    anchors.verticalCenter: combobox_column.verticalCenter

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
                    var series1 = chart.createSeries(ChartView.SeriesTypeLine,"tag 1",time_axis,axisY)
                    var series2 = chart.createSeries(ChartView.SeriesTypeLine,"tag 1",time_axis,axisY)
                    var series3 = chart.createSeries(ChartView.SeriesTypeLine,"tag 1",time_axis,axisY)
                    var series4 = chart.createSeries(ChartView.SeriesTypeLine,"tag 1",time_axis,axisY)
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

                        var tagboxes_info = {"tagbox_1" : [tagbox1_active, tagbox_1.currentText, 0], "tagbox_2" : [tagbox2_active, tagbox_2.currentText, 1], "tagbox_3" : [tagbox3_active, tagbox_3.currentText, 2], "tagbox_4" : [tagbox4_active, tagbox_4.currentText, 3]}
                        var active_tagboxes = who_active(tagboxes_info)
                        update_chart(active_tagboxes)
                    }

                    function who_active(tagbox_dict){
                        var active_elements = {}
                        for (let tag in tagbox_dict){
                            if (tagbox_dict[tag][0] && tagbox_dict[tag][1] != "Seleccione un tag..."){
                                active_elements[tag] = [tagbox_dict[tag][1], tagbox_dict[tag][2]]
                            }
                        }
                        return active_elements
                    }

                    function update_chart(tag_dict){
                        var tag_names = []
                        for (let tag in tag_dict){
                            tag_names.push(tag_dict[tag][0])
                        }
                        if (tag_names.length != 0){
                            var tagbox_values = manager.update_series(tag_names, plc_path)
                            var counter = 0
                            for (let element in tag_dict){
                                chart.series(tag_dict[element][1]).append(time_axis.max, tagbox_values[counter])
                                counter++
                            }
                        }
                    }
                }
            }
        }
        Tab {
            title: "3rd page"
            Rectangle {
                color: "green"
                width: frame.width
                height: frame.height
            }
        }
    }
}
