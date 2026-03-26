/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

// Hover-activated titlebar replacement for clean view (frameless) mode.
// Sits at the top of the contentItem at z=200. The HoverHandler detects
// the mouse within the barHeight strip; the bar fades in/out in response.
Item {
    id: root

    readonly property int barHeight: 36

    z: 200
    height: barHeight

    HoverHandler {
        id: hoverHandler
    }

    Rectangle {
        id: titleBar

        anchors.fill: parent
        color: Qt.alpha(Kirigami.Theme.backgroundColor, 0.92)
        opacity: hoverHandler.hovered ? 1.0 : 0.0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: Kirigami.Units.shortDuration }
        }

        // Drag anywhere on the bar to move the window
        DragHandler {
            grabPermissions: PointerHandler.CanTakeOverFromAnything
            onActiveChanged: if (active) root.Window.window.startSystemMove()
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Kirigami.Units.smallSpacing
            anchors.rightMargin: Kirigami.Units.smallSpacing
            spacing: 0

            Label {
                text: root.Window.window.title
                elide: Text.ElideRight
                Layout.fillWidth: true
                leftPadding: Kirigami.Units.smallSpacing
            }

            ToolButton {
                display: AbstractButton.IconOnly
                icon.name: "window-minimize"
                flat: true
                focusPolicy: Qt.NoFocus
                onClicked: root.Window.window.showMinimized()
                ToolTip.visible: hovered
                ToolTip.text: i18nc("@info:tooltip", "Minimize")
            }
            ToolButton {
                display: AbstractButton.IconOnly
                icon.name: root.Window.window.visibility === Window.Maximized
                           ? "window-restore" : "window-maximize"
                flat: true
                focusPolicy: Qt.NoFocus
                onClicked: root.Window.window.visibility === Window.Maximized
                           ? root.Window.window.showNormal()
                           : root.Window.window.showMaximized()
                ToolTip.visible: hovered
                ToolTip.text: root.Window.window.visibility === Window.Maximized
                              ? i18nc("@info:tooltip", "Restore") : i18nc("@info:tooltip", "Maximize")
            }
            ToolButton {
                display: AbstractButton.IconOnly
                icon.name: "window-close"
                flat: true
                focusPolicy: Qt.NoFocus
                onClicked: root.Window.window.close()
                ToolTip.visible: hovered
                ToolTip.text: i18nc("@info:tooltip", "Close")
            }
        }
    }
}
