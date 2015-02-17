import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
ApplicationWindow {
    id: mainRect
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    property var nums: settings.value("NumArray", [1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9]);
    property var backupNums: []
    property var pair: [];
    property int score: settings.value("Score", 0);
    property int time: settings.value("Time", 0);

    function integerDivision(x, y){
        return (x-x%y)/y
    }
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
        var k = 0;
        for(var k = 0; k < nums.length; k+=9){
            if(nums[k] === 0){
                for(var i = k+1; i < k+9; i++){
                    if(nums[i] !== 0)
                        break;
                    if(i === k+8){
                       nums.splice(k,9);
                       k-=9;
                    }
                }
            }
        }

        var nms = mainRect.nums;
        nms.forEach(function(value, index, array1){
            if(value != 0)
                nums.push(value);
        })
        rep.model = nums;
        settings.setValue("NumArray", mainRect.nums);
    }
    function secToString(time) {
        var seconds = time%60;
        if(seconds < 10)
            seconds = "0" + String(seconds)
        else
            seconds = String(seconds)
        time = integerDivision(time,60);
        var minutes = time%60;
        time = integerDivision(time,60);
        var hours = time%24;
        var days = integerDivision(time,24);
        var string = "";
        if (days!=0) {
                string = days +":"+ hours +":"+  minutes +":"+ seconds;
        } else if (hours!=0) {
                string = hours +":"+ minutes +":"+ seconds;
        } else {
                string = minutes +":"+ seconds;
        }
        return string;
    }

    Timer{
        interval: 1000; running: true; repeat: true
        onTriggered:{
            mainRect.time++;
            settings.setValue("Time", mainRect.time);
        }
    }

    RowLayout{
        id: statRow
        anchors.top: parent.top
        width: parent.width
        height: 50
        Label{
            id: scoreLabel
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Score: " + mainRect.score

//            font.pixelSize:
        }
        Label{
            id: timeLabel
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Time: "+ mainRect.secToString(mainRect.time)

            font.pixelSize: score.height/2
        }
    }

    Flickable{
        anchors{
            top: statRow.bottom
            right: parent.right
            left: parent.left
            bottom: btnRow.top
        }
        flickableDirection: Flickable.VerticalFlick

        Grid{
            id: grid
            columns: 9
            spacing: mainRect.width/10/9
            Repeater{
                id: rep
                model: mainRect.nums
                Connections{
                    target: mainRect
                    onUpdated: {
                        rep.model = mainRect.nums;
                    }
                }

                delegate: Cell{
                    id: rect
                    width: mainRect.width/10
                    height: mainRect.width/10
                    property int row: index/9
                    property int column: index%9
                    state: n == 0 ? "Delete" : "Default"
//                    property bool vis: modelData == 0 ? false : true;
                    n: modelData

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.border.width = 2
                        onExited: parent.border.width = 1
                        onClicked:{
                            if((rect.state == "Default") || (rect.state == "Check")){
                                if(pair.length == 1){
                                        if(mainRect.checkPair(pair[0], rect)){
                                            mainRect.backupNums =  mainRect.nums.slice(0);
                                            mainRect.nums[pair[0].row*9 + pair[0].column] = 0;
                                            mainRect.nums[rect.row*9 + rect.column] = 0;
                                            pair[0].state = "Delete"
                                            rect.state = "Delete";
                                            mainRect.pair.length = 0;
                                            mainRect.score += 10;
                                            settings.setValue("Score", mainRect.score);

                                        }else{
                                            pair[0].state = "Default";
                                            rect.state = "Default";
                                            mainRect.pair.length = 0;
                                        }
                                }else
                                {
                                    rect.state = "Check";
                                    pair.push( rect );
                                }
                                settings.setValue("NumArray", mainRect.nums);
                            }

                        }
                    }
                }
            }
        }
        contentHeight: grid.height
        contentWidth: grid.width
    }
    RowLayout{
        id: btnRow
        anchors.bottom: parent.bottom
        width: parent.width
        height: 50
        Button{
            id: undoButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Undo"
            visible: mainRect.backupNums.length
//            checkable: backupNums.length == 0 ? false : true
            onClicked: {
                if(mainRect.backupNums.length !== 0){
                    mainRect.nums = mainRect.backupNums.slice(0);
                    mainRect.backupNums.length = 0;
                    rep.model = 0;
                    mainRect.score -= 10;
                    rep.model = mainRect.nums;
                }
            }

        }
        Button{
            id: restartButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Restart"
            onClicked: {
                mainRect.nums = [1,1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9];
                settings.setValue("NumArray", mainRect.nums);
                rep.model = 0;
                rep.model = mainRect.nums;
                mainRect.score = 0;
                settings.setValue("Score", mainRect.score);
                mainRect.time = 0
                settings.setValue("Time", mainRect.time);
                mainRect.backupNums.length = 0;
            }

        }
        Button{
            id: nextStepButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Next step"
            onClicked: mainRect.nextStep()
        }
    }



}
