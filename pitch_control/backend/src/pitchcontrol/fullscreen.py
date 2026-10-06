"""Full screen for the desktop app.

macOS native full screen keeps windows below the camera notch of newer MacBooks and paints the
strip beside it black. Instead, PitchControl hides the menu bar and Dock and stretches a borderless
window over the whole screen, notch strip included; the UI keeps that 32 px strip free in the middle
(top header row: logo left, indicators right). The green window button becomes a plain zoom.

Other platforms use pywebview's own full screen (no notch there).
"""

from __future__ import annotations

import logging
import sys
import threading

log = logging.getLogger(__name__)

# AppKit constants (kept numeric so this module imports without AppKit on other platforms)
_HIDE_DOCK = 1 << 1  # NSApplicationPresentationHideDock
_HIDE_MENU_BAR = 1 << 3  # NSApplicationPresentationHideMenuBar
_STYLE_BORDERLESS = 0  # NSWindowStyleMaskBorderless
_FULLSCREEN_NONE = 1 << 9  # NSWindowCollectionBehaviorFullScreenNone: green button = zoom


class Fullscreen:
    def __init__(self, window):
        self.window = window  # pywebview Window
        self.active = False
        self._saved: tuple | None = None  # (frame, style mask, shadow) to restore
        self._lock = threading.Lock()
        self.mac = sys.platform == "darwin"

    # -- helpers
    def _on_main(self, fn) -> None:
        from PyObjCTools import AppHelper

        AppHelper.callAfter(fn)

    def setup(self) -> None:
        """After the window is shown: route the green button to zoom instead of native full screen."""
        if not self.mac:
            return

        def apply():
            ns = self.window.native
            if ns is not None:
                ns.setCollectionBehavior_(_FULLSCREEN_NONE)

        self._on_main(apply)

    # -- public
    def set(self, on: bool) -> bool:
        with self._lock:
            if on == self.active:
                return self.active
            self.active = on
        if not self.mac:
            self.window.toggle_fullscreen()
            return on
        self._on_main(lambda: self._apply_mac(on))
        return on

    def toggle(self) -> bool:
        return self.set(not self.active)

    def _apply_mac(self, on: bool) -> None:
        import AppKit

        ns = self.window.native
        if ns is None:
            return
        app = AppKit.NSApplication.sharedApplication()
        if on:
            self._saved = (ns.frame(), ns.styleMask(), ns.hasShadow())
            app.setPresentationOptions_(_HIDE_DOCK | _HIDE_MENU_BAR)
            ns.setStyleMask_(_STYLE_BORDERLESS)
            # the window shadow includes a 1 px outline, visible at the rounded screen corners
            ns.setHasShadow_(False)
            screen = ns.screen() or AppKit.NSScreen.mainScreen()
            ns.setFrame_display_(screen.frame(), True)
            ns.makeKeyAndOrderFront_(None)
            ns.makeFirstResponder_(ns.contentView())
            log.info("full screen on: window %s, screen %s, shadow %s", _size(ns.frame()), _size(screen.frame()), ns.hasShadow())
        else:
            frame, style, shadow = self._saved or (ns.frame(), ns.styleMask(), True)
            ns.setStyleMask_(style)
            ns.setHasShadow_(shadow)
            ns.setFrame_display_(frame, True)
            app.setPresentationOptions_(0)
            ns.makeFirstResponder_(ns.contentView())
            log.info("full screen off: window %s", _size(ns.frame()))


def _size(rect) -> str:
    return f"{rect.size.width:.0f}x{rect.size.height:.0f} at ({rect.origin.x:.0f},{rect.origin.y:.0f})"
