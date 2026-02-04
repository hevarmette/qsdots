import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Shapes

ShapePath {
    id: root

    required property Wrapper wrapper
    required property bool invertBottomRounding // kept for compatibility can be ignored, i think
    readonly property real rounding: wrapper.isDetached ? Appearance.rounding.normal : Config.border.rounding
    readonly property real topRounding: wrapper.isDetached ? rounding : 0 
    readonly property bool flatten: wrapper.width < rounding * 2
    readonly property real roundingX: flatten ? wrapper.width / 2 : rounding
    property real ibr: invertBottomRounding ? -1 : 1

    property real sideRounding: startX > 0 ? -1 : 1

    strokeWidth: -1
    fillColor: Colours.palette.m3surface
    startX: 0
    startY: 0

    // Top Edge (Line to Right)
    PathLine {
        relativeX: root.wrapper.width
        relativeY: 0
    }
    // top right corner rounding
    PathArc {
        relativeX: 0
        relativeY: root.topRounding
        radiusX: root.topRounding
        radiusY: root.topRounding
    }
    // Right Edge (Line down)
    PathLine {
        x: root.wrapper.width
        y: root.wrapper.height - root.rounding
    }
    PathArc {
        relativeX: root.roundingX
        relativeY: root.rounding
        radiusX: Math.min(root.rounding, root.wrapper.width)
        radiusY: root.rounding
    }
    // Bottom-Right Corner
    PathArc {
        relativeX: -root.rounding
        relativeY: root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }
    // Bottom Edge (Line Left)
    PathLine {
        x: root.rounding
        y: root.wrapper.height
    }
    // Bottom-Left Corner
    PathArc {
        relativeX: -root.rounding
        relativeY: -root.rounding
        radiusX: root.rounding
        radiusY: root.rounding
    }
    // Left Edge (Line Up)
    PathLine {
        x: 0
        y: 0 // Back to top
    }
    // Close the path
    PathLine {
        x: 0
        y: 0
    }

    Behavior on fillColor {
        CAnim {}
    }

    Behavior on ibr {
        Anim {}
    }

    Behavior on sideRounding {
        Anim {}
    }
}
