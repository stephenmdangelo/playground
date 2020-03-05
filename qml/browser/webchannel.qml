import QtQuick 2.9
import QtWebEngine 1.5
import QtWebChannel 1.0
import QtQuick.Controls 2.0 as Controls

Item {
    width: 800
    height: 600

    QtObject {
        id: web_channel_interface

        WebChannel.id: "vue"

        // To be connected to in VUE Web
        signal co_pilot_started()
        signal co_pilot_finished()
        signal remote_client_finished()

        // To be called from VUE Web
        function co_pilot_response(response) {
            co_pilot_response_received(response)
        }
        signal co_pilot_response_received(string response)

        function connect_remote_client(ip, supports_co_pilot) {
            console.log("Connecting to remote client...", ip, co_pilot)
        }
    }

    Row {
        id: top_bar
        spacing: 16
        anchors.top: parent.top

        Controls.Button {
            id: co_pilot_button
            onPressed: web_channel_interface.co_pilot_started()
            onReleased: web_channel_interface.co_pilot_finished()
            text: "Co-Pilot"
        }

        Text {
            id: status_text
            anchors.verticalCenter: parent.verticalCenter

            Connections {
                target: web_channel_interface
                onCo_pilot_response_received: {
                    console.log("Received co-pilot response:", response)
                    status_text.text = "Response: " + response
                }
                onCo_pilot_started: {
                    status_text.text = "Listening..."
                }
            }
        }
    }

    WebEngineView {
        id: webview
        url: "webchannel.html"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: top_bar.bottom

        webChannel: WebChannel { registeredObjects: [web_channel_interface] }

        onFeaturePermissionRequested: {
            if (feature === WebEngineView.MediaAudioVideoCapture) {
                grantFeaturePermission(securityOrigin, feature, true)
            } else
            if (feature === WebEngineView.MediaAudioCapture) {
                grantFeaturePermission(securityOrigin, feature, true)
            } else
            if (feature === WebEngineView.MediaVideoCapture) {
                grantFeaturePermission(securityOrigin, feature, true)
            }
        }
        onCertificateError: {
            console.info("Certificate error.", error.description)
            error.ignoreCertificateError()
        }
        onJavaScriptConsoleMessage: {
            switch(level) {
                case WebEngineView.InfoMessageLevel:
                    console.info(message, "Source", sourceID, "Line", lineNumber)
                    break;
                case WebEngineView.WarningMessageLevel:
                    console.warn(message, "Source", sourceID, "Line", lineNumber)
                    break;
                case WebEngineView.ErrorMessageLevel:
                    console.error(message, "Source", sourceID, "Line", lineNumber)
                    break;
            }
        }
    }
}
