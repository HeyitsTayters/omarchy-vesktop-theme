import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "dev.tayters.discord"

  readonly property bool running: Hyprland.toplevels.values.some(function(window) {
    return !!window.wayland && window.wayland.appId === "vesktop"
  })

  function open() {
    if (root.bar) root.bar.run("omarchy-launch-or-focus vesktop")
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  ShellIpc {
    target: "dev.tayters.discord"

    function open(): void { root.open() }
    function status(): string { return root.running ? "running" : "stopped" }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: String.fromCodePoint(0xf066f)  // md-discord
    slotSize: Style.bar.statusSlot
    dimmed: !root.running
    tooltipText: root.running ? "Discord" : "Open Discord"
    onPressed: root.open()
  }
}
