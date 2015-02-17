import QtQuick 2.0

Rectangle {
    id: rect
    height: width
    property int n;

    border.color: "black"
    Text{
        id: num
        anchors.centerIn: parent
        font.pointSize: 14
        text: rect.modelData == 0 ? "" : parent.n
    }

    MouseArea{
        id: ma
        anchors.fill: parent
        hoverEnabled: true
    }

    state: "Default"
    states: [
        State{
            name: "Default"
            PropertyChanges {
                target: rect
                color: "skyblue"
                border.width: 1
                radius: rect.width/10
            }
            PropertyChanges {
                target: num
                text: rect.n
            }
        },
//        State{
//            name: "Select"
//            when: ma.containsMouse
//            PropertyChanges {
//                target: rect
//                color: "skyblue"
//                border.width: 2
//                radius: width/10
//            }
//            PropertyChanges {
//                target: num
//                text: rect.n
//            }
//        },
        State{
            name: "Check"
            PropertyChanges {
                target: rect
                color: "lightgreen"
                border.width: 2
                radius: width/10
            }
            PropertyChanges {
                target: num
                text: rect.n
            }
        },
        State{
            name: "Delete"
            PropertyChanges {
                target: rect
                color: "gray"
                border.width: 0
                radius: 0
            }
            PropertyChanges {
                target: num
                text: ""
            }
        }

    ]
}
