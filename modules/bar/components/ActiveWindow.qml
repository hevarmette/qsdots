pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.utils
import qs.config
import QtQuick

Item {
    id: root

    required property var bar
    required property Brightness.Monitor monitor
    property color colour: Colours.palette.m3primary

    readonly property int maxWidth: {
         const otherModules = bar.children.filter(c => c.id && c.item !== this && c.id !== "spacer");
         const otherWidth = otherModules.reduce((acc, curr) => acc + (curr.item.nonAnimWidth ?? curr.width), 0);
         // Calculate remaining width
         return bar.width - otherWidth - bar.spacing * (bar.children.length - 1) - bar.hPadding * 2;
    }
    property Title current: text1

    clip: true
    implicitHeight: Math.max(icon.implicitHeight, current.implicitHeight)
    implicitWidth: icon.implicitWidth + current.implicitWidth + current.anchors.leftMargin

    MaterialIcon {
        id: icon

        anchors.left: parent.left 
        anchors.verticalCenter: parent.verticalCenter

        animate: true
        text: Icons.getAppCategoryIcon(Hypr.activeToplevel?.lastIpcObject.class, "desktop_windows")
        color: root.colour
    }

    Title {
        id: text1
    }

    Title {
        id: text2
    }

    TextMetrics {
        id: metrics

        text: Hypr.activeToplevel?.title ?? qsTr("Desktop")
        font.pointSize: Appearance.font.size.smaller
        font.family: Appearance.font.family.mono
        elide: Qt.ElideRight
        elideWidth: root.maxWidth - icon.width

        onTextChanged: {
            const next = root.current === text1 ? text2 : text1;
            next.text = elidedText;
            root.current = next;
        }
        onElideWidthChanged: root.current.text = elidedText
    }

    Behavior on implicitHeight {
        Anim {
            duration: Appearance.anim.durations.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }

    component Title: StyledText {
        id: text

        anchors.left: icon.right
        anchors.verticalCenter: icon.verticalCenter
        anchors.top: undefined // Clear top anchor
        anchors.horizontalCenter: undefined // Clear horizontalCenter
        
        anchors.leftMargin: Appearance.spacing.small

        font.pointSize: metrics.font.pointSize
        font.family: metrics.font.family
        color: root.colour
        opacity: root.current === this ? 1 : 0

        // transform: [
        //     Translate {
        //         x: Config.bar.activeWindow.inverted ? -implicitWidth + text.implicitHeight : 0
        //     },
        //     Rotation {
        //         angle: Config.bar.activeWindow.inverted ? 270 : 90
        //         origin.x: text.implicitHeight / 2
        //         origin.y: text.implicitHeight / 2
        //     }
        // ]

        width: implicitWidth
        height: implicitHeight

        Behavior on opacity {
            Anim {}
        }
    }
}
