import QtQuick.Layouts 1.3
import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property alias lowButton: xplus1
    property alias highButton: xplus10
    Button{
        id: xplus1

        width: 40
        height: 80
        style: ButtonStyle{
            label: Image {
                source: "./images/arrow.png";
                fillMode: Image.PreserveAspectFit;
                horizontalAlignment: Image.AlignLeft;
            }
        }
    }
    Button{
        id: xplus10

        width: 66
        height: 80
        anchors.left: xplus1.right
        anchors.leftMargin: 10
        style: ButtonStyle{
            label: Image {
                source: "./images/doublearrow.png";
                fillMode: Image.PreserveAspectFit;
                horizontalAlignment: Image.AlignLeft;
            }
        }
    }
}
