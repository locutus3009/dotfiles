import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.config // KAuthorized
import org.kde.kcmutils // KCMLauncher
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrolsaddons
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    property string bing: "https://www.bing.com/search?q="
    property string duckduckgo: "https://duckduckgo.com/?q="
    property string ecosia: "https://www.ecosia.org/search?q="
    property string google: "https://www.google.com/search?q="
    property string qwant: "https://www.qwant.com/?q="
    property string startpage: "https://www.startpage.com/do/search?q="

    function executeCommand(text) {
        let command = "";
        if (Plasmoid.configuration.searchEngine === "bing")
            command = bing;
        else if (Plasmoid.configuration.searchEngine === "duckduckgo")
            command = duckduckgo;
        else if (Plasmoid.configuration.searchEngine === "ecosia")
            command = ecosia;
        else if (Plasmoid.configuration.searchEngine === "google")
            command = google;
        else if (Plasmoid.configuration.searchEngine === "qwant")
            command = qwant;
        else if (Plasmoid.configuration.searchEngine === "startpage")
            command = startpage;
        command += text.replace(/ /g, "+"); // replace spaces with +
        command = "xdg-open " + command;
        executable.exec(command);
    }

    // this removes the tooltip shown when hovering over the Plasmoid
    toolTipSubText: ""
    toolTipMainText: ""
    Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground | PlasmaCore.Types.ConfigurableBackground
    width: Kirigami.Units.gridUnit * 10
    height: Kirigami.Units.gridUnit * 4
    preferredRepresentation: compactRepresentation

    Plasma5Support.DataSource {
        id: executable

        function exec(cmd) {
            executable.connectSource(cmd);
        }

        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)
    }

    // empty item to prevent the full representation from being shown
    fullRepresentation: Item {
    }

    compactRepresentation: CompactRepresentation {
    }

}
