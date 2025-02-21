import QtQuick 2.7
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.7
import io.thp.pyotherside 1.5

ApplicationWindow {
    visible: true
    title: qsTr("Ubroxy - Proxy Configuration")
    width: 600
    height: 900
    
    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("../src/")); // Ensure the module path is correct

            importModule("main", function() {
                console.log('Python Module Loaded Successfully !!!!')
            });
        }

        onError: {
            console.log("Python error: " + traceback);
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("Menu")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit()
            }
        }
    }

    Column {
        width: parent.width
        height: parent.height
        spacing: 10

        // TabBar for navigation
        TabBar {
            id: tabBar
            width: parent.width
            height: implicitHeight

            TabButton { text: qsTr("Global Config") }
            TabButton { text: qsTr("WiFi Config") }
            TabButton { text: qsTr("VPN Config") }
        }

        // StackLayout for content
        StackLayout {
            id: stackLayout
            width: parent.width
            height: parent.height - tabBar.height - parent.spacing // Fill remaining space
            currentIndex: tabBar.currentIndex

            // Global Config Page
            Page {
                Column {
                    spacing: 10
                    anchors.centerIn: parent
                    Rectangle {
                        width: parent.width
                        height: 40
                        color: "#2E86C1"  // Blue background
                        Label {
                            text: qsTr("Global Proxy Settings")
                            color: "white"
                            font.bold: true
                            font.pointSize: 16
                            anchors.centerIn: parent
                        }
                    }

                    Label { 
                        text: qsTr("HTTP Proxy")
                        font.bold: true
                        font.pointSize: 14
                    }
                    TextField {
                        id: globalHttpProxy
                        placeholderText: qsTr("IP")
                        width: 300
                    }
                    TextField {
                        id: globalHttpPort
                        placeholderText: qsTr("Port")
                        width: 300
                        validator: IntValidator { bottom: 1; top: 65535 } // Valid port range
                    }
                    Label { 
                        text: qsTr("HTTPS Proxy")
                        font.bold: true
                        font.pointSize: 14
                    }
                    TextField {
                        id: globalHttpsProxy
                        placeholderText: qsTr("IP")
                        width: 300
                    }
                    TextField {
                        id: globalHttpsPort
                        placeholderText: qsTr("Port")
                        width: 300
                        validator: IntValidator { bottom: 1; top: 65535 } // Valid port range
                    }
                    Label {
                        text: qsTr("Proxy Exceptions")
                        font.bold: true
                        font.pointSize: 14
                    }

                    Row {
                        spacing: 10

                        TextField {
                            id: noProxyInput
                            placeholderText: qsTr("Enter domain or IP")
                            width: 200
                        }

                        Button {
                            text: qsTr("Add")
                            onClicked: {
                                if (noProxyInput.text.trim() !== "") {
                                    noProxyModel.append({ "entry": noProxyInput.text.trim() });
                                    noProxyInput.text = "";  // Clear input field
                                }
                            }
                        }
                    }

                    ListView {
                        id: noProxyList
                        width: 300
                        height: 100
                        model: ListModel { 
                            id: noProxyModel
                            ListElement { entry: "localhost" }
                            ListElement { entry: "127.0.0.1" }
                        }

                        delegate: Row {
                            spacing: 20
                            Text {
                                text: model.entry
                                font.pointSize: 10
                            }
                            Button {
                                width: 20
                                height: 20
                                text: "X"
                                onClicked: noProxyModel.remove(index)
                                background: Rectangle {
                                    color: "red"
                                    radius: 10
                                }
                            }
                        }
                        spacing: 10
                    }
                    Button {
                        text: qsTr("Save Global Config")
                        onClicked: {
                            var globalNoProxyArray = [];
                            for(var i =0; i<noProxyModel.count; i++){
                                globalNoProxyArray.push(noProxyModel.get(i).entry);
                            }
                            python.call("main.save_global_config", [globalHttpProxy.text, globalHttpPort.text, globalHttpsProxy.text, globalHttpsPort.text, globalNoProxyArray], function(response){
                                console.log('Global Save Config Response: ', response);
                            });
                        }
                    }
                }
            }

            // WiFi Config Page
            Page {
                Column {
                    spacing: 10
                    anchors.centerIn: parent

                    Label { text: qsTr("WiFi Proxy Settings") }
                    ComboBox {
                        id: wifiNetwork
                        width: 300
                        model: ["Home WiFi", "Office WiFi", "Public WiFi"]
                    }
                    TextField {
                        id: wifiProxy
                        placeholderText: qsTr("Proxy Server")
                        width: 300
                    }
                    TextField {
                        id: wifiPort
                        placeholderText: qsTr("Port")
                        width: 300
                        validator: IntValidator { bottom: 1; top: 65535 } // Valid port range
                    }
                    Button {
                        text: qsTr("Save WiFi Config")
                        onClicked: console.log("WiFi Config Saved: " + wifiNetwork.currentText + " -> " + wifiProxy.text + ":" + wifiPort.text)
                    }
                }
            }

            // VPN Config Page
            Page {
                Column {
                    spacing: 10
                    anchors.centerIn: parent

                    Label { text: qsTr("VPN Proxy Settings") }
                    ComboBox {
                        id: vpnProfile
                        width: 300
                        model: ["Work VPN", "Personal VPN", "Custom VPN"]
                    }
                    TextField {
                        id: vpnProxy
                        placeholderText: qsTr("Proxy Server")
                        width: 300
                    }
                    TextField {
                        id: vpnPort
                        placeholderText: qsTr("Port")
                        width: 300
                        validator: IntValidator { bottom: 1; top: 65535 } // Valid port range
                    }
                    Button {
                        text: qsTr("Save VPN Config")
                        onClicked: console.log("VPN Config Saved: " + vpnProfile.currentText + " -> " + vpnProxy.text + ":" + vpnPort.text)
                    }
                }
            }
        }
    }
}