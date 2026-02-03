import qs.services
import qs.config
import qs.modules.osd as Osd
import qs.modules.notifications as Notifications
import qs.modules.session as Session
import qs.modules.launcher as Launcher
import qs.modules.dashboard as Dashboard
import qs.modules.bar.popouts as BarPopouts
import qs.modules.utilities as Utilities
import qs.modules.sidebar as Sidebar
import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property Panels panels
    required property Item bar

    anchors.fill: parent
    anchors.margins: Config.border.thickness
    anchors.leftMargin: bar.implicitWidth
    preferredRendererType: Shape.CurveRenderer

    Osd.Background {
        wrapper: root.panels.osd

        startX: root.width - root.panels.session.width - root.panels.sidebar.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }

    Notifications.Background {
        wrapper: root.panels.notifications
        sidebar: sidebar

        startX: root.width
        startY: 0
    }

    Session.Background {
        wrapper: root.panels.session

        startX: root.width - root.panels.sidebar.width
        startY: (root.height - wrapper.height) / 2 - rounding
    }

    Launcher.Background {
        wrapper: root.panels.launcher

        startX: (root.width - wrapper.width) / 2 - rounding
        startY: root.height
    }

    Dashboard.Background {
        wrapper: root.panels.dashboard

        startX: (root.width - wrapper.width) / 2
        startY: wrapper.y + rounding
    }

    BarPopouts.Background {
        wrapper: root.panels.popouts
        
        // Check if we are close to right edge for corner rounding logic? 
        // For now, let's just simplify the start coordinates.
        
        // Invert rounding if near the right edge? 
        // invertBottomRounding logic was for Y axis. We might need invertRightRounding now?
        // Let's stick to the basics first:
        
        // Start drawing from the top edge of the popout (y=0)
        // Offset X by the relative center of the trigger
        startX: wrapper.currentCenter - wrapper.x
        startY: 0 
        
        // NOTE: might need to edit `bar/popouts/Background.qml` to handle Top-side drawing 
        // if it's hardcoded to draw a left-side tail. 
        // If the shape looks weird, will fix `bar/popouts/Background.qml` in the next step.
    }

    Utilities.Background {
        wrapper: root.panels.utilities
        sidebar: sidebar

        startX: root.width
        startY: root.height
    }

    Sidebar.Background {
        id: sidebar

        wrapper: root.panels.sidebar
        panels: root.panels

        startX: root.width
        startY: root.panels.notifications.height
    }
}
