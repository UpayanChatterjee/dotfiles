pragma ComponentBehavior: Bound

import qs.components
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import QtQuick

Variants {
    model: Quickshell.screens

    Scope {
        id: scope
        required property ShellScreen modelData

        StyledWindow {
            id: osdWin
            
            // This is the magic line: Force it to stay on top of EVERYTHING
            layer: Layer.Overlay
            
            screen: scope.modelData
            anchors.fill: parent
            
            // Make the window click-through so it doesn't steal focus from games
            mask: Region {} 

            // Connect to the same visibility system
            PersistentProperties {
                id: visibilities
                property bool osd
                Component.onCompleted: Visibilities.load(scope.modelData, this)
            }

            // Load the actual OSD content
            Loader {
                id: osdLoader
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: Config.osd.sizes.sliderHeight / 2 // Adjust margin as needed

                // Only load when needed
                active: Config.osd.enabled
                
                source: "Wrapper.qml"
                
                // Pass required properties to the wrapper
                onLoaded: {
                    item.screen = scope.modelData;
                    item.visibilities = visibilities;
                }
            }
        }
    }
}
