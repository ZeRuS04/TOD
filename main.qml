import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    id: mainRect
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    property var nums: [1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9];
    property var pair: [];
    signal updated();
    function checkPair( item1, item2){
        if((item2.n != item1.n) && ((item2.n + item1.n)!= 10))
            return false;                           // числа разные и не дают в сумме 10

        var dx, i;
        if((Math.abs(item1.row-item2.row) == 0)){       // на одной строке


            dx = item1.column-item2.column              // расстояние между клетками
            i = item2.column + dx/Math.abs(dx)
            while(i !== item1.column){
                if((mainRect.nums[item2.row*9 + i] !== 0)){
                    // встретили не нулевой элемент между выделеными элементами
                    return false;
                }
                i +=   dx/Math.abs(dx);
            }

            return true;
        }

        if((Math.abs(item1.column-item2.column) == 0)){       // в одной колонке


            dx = item1.row-item2.row              // расстояние между клетками
            i = item2.row + dx/Math.abs(dx)
            while(i !== item1.row){
                if((mainRect.nums[i*9 + item2.column] !== 0)){
                    // встретили не нулевой элемент между выделеными элементами
                    return false;
                }
                i +=   dx/Math.abs(dx);
            }

            return true;
        }

        return false;
    }

    function nextStep(){
        var nms = mainRect.nums;
        nms.forEach(function(value, index, array1){
            if(value != 0)
                nums.push(value);
        })
        rep.model = nums;
    }

    ScrollView{
        anchors.fill: parent
        Grid{
            columns: 9

            Repeater{
                id: rep
                model: mainRect.nums
                Connections{
                    target: mainRect
                    onUpdated: {
                        rep.model = mainRect.nums;
                    }
                }

                delegate: Rectangle{
                    id: rect
                    width: mainRect.width/9
                    height: mainRect.width/9
                    property int row: index/9
                    property int column: index%9
                    property bool vis: modelData == 0 ? false : true;
                    property int n: modelData
                    color: vis ? "skyblue" : "red"
                    border.color: "black"
                    border.width: 1
//                    states: [
//                        State{

//                        },

//                    ]
                    Text{
                        id: num
    //                    anchors.fill: parent
                        anchors.centerIn: parent
                        font.pointSize: 14
                        text: rect.modelData == 0 ? "" : parent.n
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.border.width = 2
                        onExited: parent.border.width = 1
                        onClicked:{
                            if(rect.vis){
                                if(pair.length == 1){
                                    // проверка -  нажата смежная ли клетка
                                    // если смежная то чекпэир()
                                        if(mainRect.checkPair(pair[0], rect)){
                                            mainRect.nums[pair[0].row*9 + pair[0].column] = 0;
                                            mainRect.nums[rect.row*9 + rect.column] = 0;
                                            rect.vis = false;
                                            pair[0].vis = false;
                                            pair[0].color = "red";
                                            mainRect.pair.length = 0;

                                        }else{
                                            pair[0].color = "skyblue";
                                            mainRect.pair.length = 0;
                                        }
                                }else
                                {
                                    rect.color = "white";
                                    pair.push( rect );
                                }
                            }

                        }
                    }
                }
            }
        }
    }
    Button{
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40
        text: "Next step"
        onClicked: mainRect.nextStep()
    }

}
