import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import HFR.OpenCV 1.0
import HFR.IDCard 1.0

Window {
    id: root;
    objectName: "root";
    visible: true;
    minimumWidth: 880;
    minimumHeight: 650;
    title: qsTr("凯狮人脸识别系统");

    Rectangle {
        id: rectleft;
        width: 220;
        height: root.height - anchors.topMargin - anchors.bottomMargin;
        anchors.margins: 5;
        anchors.left: parent.left;
        anchors.top: parent.top;

        Image {
            id: idCardImg;
            width: 102;
            height: 126;
            anchors.topMargin: 0;
            anchors.leftMargin: 0;
            //anchors.horizontalCenter: parent.horizontalCenter;
            fillMode: Image.PreserveAspectFit;
            source: "qrc:/HFR/Resources/image/小.jpg";
        }

        GridLayout {
            id: gridBasicInfo;
            anchors.left: parent.left;
            anchors.leftMargin: 5;
            anchors.top: idCardImg.bottom;
            anchors.topMargin: 5;
            anchors.horizontalCenter: parent.horizontalCenter;
            rows: 3;
            columns: 2;
            rowSpacing: 4;
            columnSpacing: 4;
            flow: GridLayout.LeftToRight;
            width: Layout.preferredWidth;

            Text{
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                font.family: "黑体";
                font.pixelSize: 10;
                text: qsTr("姓名");
                color: "#1569DD";
            }

            Text {
                id: txtName;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignBottom;
                font.family: "微软雅黑";
                font.pixelSize:12;
                text: "江雪桥";
            }

            Text{
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                font.family: "黑体";
                font.pixelSize: 10;
                text: qsTr("性别");
                color: "#1569DD";
            }

            Text {
                id: txtSex;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignBottom;
                font.family: "微软雅黑";
                font.pixelSize: 12
                text: "男";
            }

            Text{
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                font.family: "黑体";
                font.pixelSize: 10;
                text: qsTr("民族");
                color: "#1569DD";
            }

            Text {
                id: txtNation;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignBottom;
                font.family: "微软雅黑";
                font.pixelSize: 12;
                text: "汉";
            }

            Text{
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                font.family: "黑体";
                font.pixelSize: 10;
                text: qsTr("出生");
                color: "#1569DD";
            }

            Text {
                id: txtBirthday;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignBottom;
                font.family: "微软雅黑";
                font.pixelSize: 12;
                text: "1989年12月1日";
            }
        }


        ColumnLayout {
            id: rowCardNum;
            anchors.left: parent.left;
            anchors.leftMargin: 5;
            anchors.top: gridBasicInfo.bottom;
            anchors.topMargin: 10;
            anchors.horizontalCenter: parent.horizontalCenter;

            Text{
                horizontalAlignment: Text.AlignRight;
                verticalAlignment: Text.AlignVCenter;
                font.family: "黑体";
                font.pixelSize: 10
                text: qsTr("公民身份号码");
                color: "#1569DD";
            }

            Text {
                id: txtCardNum;
                horizontalAlignment: Text.AlignLeft;
                verticalAlignment: Text.AlignBottom;
                font.family: "微软雅黑";
                font.pixelSize: 14
                text:"421003198912012317";
            }
        }

        IDCardReader {
            id: idCardReader;

            onNewIdCard: {
                var imaPath = "file:/" + photoPath;
                imaPath.replace("\\", "/");
                idCardImg.source = imaPath;
                txtName.text = name;
                txtSex.text = sex;
                txtNation.text = nation;
                txtBirthday.text = birthday;
                txtCardNum.text = cardNumber;

                grapImageListModel.clearGrapImage();
                camera1.recognize(photoPath);
            }
        }

        GroupBox {
            id: grpFunction;
            title: qsTr("高级");
            anchors.left: parent.left;
            anchors.bottom: parent.bottom;
            anchors.right: parent.right;
            height: 150;

            ColumnLayout {
                spacing: 4;

                CheckBox {
                    id: btnPreview;
                    text: qsTr("摄像头预览");
                    checked: cameraPreview.enabled;

                    onClicked: {
                        cameraPreview.enabled = (btnPreview.checkedState == Qt.Checked);
                    }
                }

                CheckBox {
                    id: btnRealTimeDetect;
                    checked: cameraPreview.liveFaceDetect;
                    text: qsTr("实时人脸检测");

                    onClicked: {
                        cameraPreview.liveFaceDetect = (btnRealTimeDetect.checkedState == Qt.Checked);
                    }
                }



                Button {
                    id: btnGrapImage;
                    Layout.minimumWidth: 120;
                    text: qsTr("手动抓图");

                    onClicked: {
                        camera1.grapImage(false, 1);
                    }
                }

                Button {
                    id: btnGrapFaceImage;
                    Layout.minimumWidth: 120;
                    text: qsTr("手动抓人脸图");

                    BusyIndicator {
                        id: busyGrapFaceImage;
                        anchors.left: parent.left;
                        anchors.leftMargin: 3;
                        anchors.top: parent.top;
                        anchors.topMargin: (btnGrapFaceImage.height - height) / 2; // 直接设置anchors.verticalCenter: parent;无效

                        running: false;

                        style: BusyIndicatorStyle {
                            indicator: Image {
                                visible: control.running
                                source: "qrc:/HFR/Resources/image/Transfer.png"
                                RotationAnimator on rotation {
                                    running: control.running
                                    loops: Animation.Infinite
                                    duration: 2000
                                    from: 0 ; to: 360
                                }
                            }
                        }
                    }

                    onClicked: {
                        camera1.grapImage(true, 5);
                    }
                }
            }
        }


    }

    Rectangle {
        id: rectright;
        anchors.margins: 5;
        anchors.left: rectleft.right;
        anchors.top: parent.top;
        width: 640;
        height: 480;

        OpenCVCamera {
            id: camera1;
            objectName: "camera1";
            enabled: true;

            onBeginGrapFaceImage: {
                btnGrapFaceImage.enabled = false;
                btnGrapFaceImage.text = qsTr("抓取人脸中...");
                busyGrapFaceImage.running = true;
            }

            onEndGrapFaceImage: {
                busyGrapFaceImage.running = false;
                btnGrapFaceImage.text = qsTr("手动抓人脸图");
                btnGrapFaceImage.enabled = true;
            }
        }

        OpenCVCameraPreview {
            id: cameraPreview;
            camera: camera1;
            enabled: true;
            liveFaceDetect: false;
            visible:true;
            anchors.fill: parent;

            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: parent.verticalCenter;
        }
    }




    Rectangle {
        id: rectGrapImage;
        anchors.left: rectleft.right;
        anchors.bottom: parent.bottom;
        anchors.right: parent.right;
        anchors.margins: 5;
        height: 130;
        radius: 6;
        color: "#FAFAFA";

        Component {
            id: grapImageDelegate;

            Rectangle {
                id: wrapper;
                width: 125;
                height: 125;

                Image {
                    id: imgGrap;
                    width: 125;
                    height: 125;
                    anchors.centerIn: parent;
                    fillMode: Image.PreserveAspectFit;
                    source: imgUri;
                }

                MouseArea {
                      hoverEnabled: true;
                      anchors.fill: imgGrap;

                      onEntered: {
                          imgBigGrap.setPos(this);
                          imgBigGrap.source = imgGrap.source;
                          imgBigGrap.visible = true;
                      }

                      onExited: {
                          imgBigGrap.visible = false;
                      }
                  }
            }
        }

        ScrollView {
            horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded;
            clip: true;
            anchors.fill: parent;

            ListView {
                id: listCapture;
                anchors.fill: parent;
                orientation: ListView.Horizontal;

                spacing: 4;
                focus: true;

                delegate: grapImageDelegate;
                model: grapImageListModel;
            }
        }


    }

    Image {
        id: imgBigGrap;
        width: 250;
        height: 250;
        z: 100;
        anchors.bottomMargin: 5;
        anchors.bottom: rectGrapImage.top;
        visible: true;

        fillMode: Image.PreserveAspectFit;

        function setPos(object) {
            var globalCoordinares = object.mapToItem(parent, 0, 0);
            var xValue = globalCoordinares.x - (imgBigGrap.width - object.width) / 2;
            if(xValue + imgBigGrap.width > parent.width) {
                xValue = parent.width - imgBigGrap.width;
            }
            imgBigGrap.x = xValue;
        }
    }
}
