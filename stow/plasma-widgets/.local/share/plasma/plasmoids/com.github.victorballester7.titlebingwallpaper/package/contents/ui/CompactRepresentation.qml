import "../src/request.js" as XHR
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kquickcontrolsaddons
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid

Item {
    id: main

    property bool showLocation: plasmoid.configuration.showLocation
    property bool oneLineMode: plasmoid.configuration.oneLineMode
    property string url: "https://www.bing.com/hpimagearchive.aspx?n=1&mkt="
    property string locale: plasmoid.configuration.locale // if it is a different string form the default ones, then it will return an english version of the image
    property string title: ""
    property string location: ""
    property int reloadIntervalMs: 5000 // time in milliseconds between two requests (to reload the text)

    function updateTitle() {
        if (plasmoid.configuration.showLocation) {
            if (plasmoid.configuration.oneLineMode) {
                if (location === "")
                    textLabel.text = title;
                else
                    textLabel.text = title + ", " + location;
            } else {
                if (location === "")
                    textLabel.text = title;
                else
                    textLabel.text = title + "\n" + location;
            }
        } else {
            textLabel.text = title;
        }
    }

    function updateRequest() {
        XHR.sendRequest(url + locale, function(response) {
            let isPlainText = response.contentType.length === 0;
            if (isPlainText && response.content !== "") {
                // After the execution of this line, fullTitle will contain an array where the first element (fullTitle[0]) is the entire matched string, and the second element (fullTitle[1]) is the content between the <copyright> tags. This is why I need to use the [1].
                let fullTitle = response.content.match(/<copyright>(.+?)<\/copyright>/)[1];
                // now fullTitle is like "Pont du Golden Gate, San Francisco, Californie, États-Unis (© Jim Patterson/Tandem Stills + Motion)". I want to remove the part after the '(' character.
                fullTitle = fullTitle.substring(0, fullTitle.indexOf(" ("));
                let numberOfCommas = fullTitle.split(",").length - 1;
                if (numberOfCommas === 0) {
                    title = fullTitle;
                    location = "";
                    // automatically set the oneLineMode to true if there is no comma in the title
                    plasmoid.configuration.emptyLocation = true;
                } else {
                    title = fullTitle.substring(0, fullTitle.indexOf(","));
                    location = fullTitle.substring(fullTitle.indexOf(",") + 2);
                    plasmoid.configuration.emptyLocation = false;
                }
            }
            updateTitle();
        });
    }

    onShowLocationChanged: {
        updateTitle();
    }
    onOneLineModeChanged: {
        updateTitle();
    }
    onLocaleChanged: {
        updateRequest();
    }
    Layout.fillHeight: false
    Layout.fillWidth: false
    Layout.minimumWidth: paintArea.width
    Layout.maximumWidth: Layout.minimumWidth
    Layout.minimumHeight: paintArea.height
    Layout.maximumHeight: Layout.minimumHeight
    Component.onCompleted: {
        updateRequest();
    }

    Timer {
        interval: main.reloadIntervalMs
        running: true
        repeat: true
        onTriggered: {
            updateRequest();
        }
    }

    Row {
        id: paintArea

        leftPadding: plasmoid.configuration.paddingLeft
        rightPadding: plasmoid.configuration.paddingRight
        topPadding: plasmoid.configuration.paddingTop
        anchors.centerIn: parent

        Label {
            // id: textLabel
            // text: "" // Call the function using the root object (now it's not correct)
            // color: theme.textColor
            // font.bold: plasmoid.configuration.bold
            // horizontalAlignment: Text.AlignHLeft
            // verticalAlignment: Text.AlignVCenter
            // font.italic: plasmoid.configuration.italic
            // font.pixelSize: plasmoid.configuration.fontSize
            // minimumPixelSize: 1
            id: textLabel

            text: ""
            horizontalAlignment: Text.AlignHLeft
            verticalAlignment: Text.AlignVCenter
            font.family: (plasmoid.configuration.autoFontAndSize || plasmoid.configuration.fontFamily.length === 0) ? PlasmaCore.Theme.defaultFont.family : plasmoid.configuration.fontFamily
            font.weight: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.weight : plasmoid.configuration.fontWeight
            font.italic: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.italic : plasmoid.configuration.italic
            font.bold: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.bold : plasmoid.configuration.bold
            font.pointSize: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.pointSize : plasmoid.configuration.fontSize
            font.underline: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.underline : plasmoid.configuration.underline
            font.strikeout: plasmoid.configuration.autoFontAndSize ? PlasmaCore.Theme.defaultFont.strikeout : plasmoid.configuration.strikeout
        }

    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.executeCommand(main.title); // Call the function using the root object
        }
    }

}
