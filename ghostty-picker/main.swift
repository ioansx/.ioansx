import Cocoa
import ApplicationServices

struct GhosttyWindow {
    let title: String
    let axElement: AXUIElement
}

func getGhosttyWindows() -> [GhosttyWindow] {
    var result: [GhosttyWindow] = []

    let ghostty = NSWorkspace.shared.runningApplications
        .first { $0.bundleIdentifier == "com.mitchellh.ghostty" }

    guard let pid = ghostty?.processIdentifier else { return result }

    let appRef = AXUIElementCreateApplication(pid)
    var windowsRef: CFTypeRef?
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &windowsRef)

    guard let windows = windowsRef as? [AXUIElement] else { return result }

    for window in windows {
        var titleRef: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
        let title = (titleRef as? String) ?? "Untitled"
        result.append(GhosttyWindow(title: title, axElement: window))
    }
    return result
}

func focusWindow(_ window: GhosttyWindow) {
    AXUIElementPerformAction(window.axElement, kAXRaiseAction as CFString)
    NSWorkspace.shared.runningApplications
        .first { $0.bundleIdentifier == "com.mitchellh.ghostty" }?
        .activate(options: .activateIgnoringOtherApps)
}

class PickerWindowController: NSWindowController {
    private var windows: [GhosttyWindow]
    private var tableView: NSTableView!

    init(windows: [GhosttyWindow]) {
        self.windows = windows

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Ghostty Windows"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.center()
        window.level = .floating

        super.init(window: window)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        guard let window = self.window else { return }

        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.autoresizingMask = [.width, .height]

        // Scroll view + table
        let scrollView = NSScrollView(frame: NSRect(x: 12, y: 12, width: 376, height: 276))
        scrollView.hasVerticalScroller = true
        scrollView.autoresizingMask = [.width, .height]

        tableView = NSTableView(frame: scrollView.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.doubleAction = #selector(rowDoubleClicked)
        tableView.target = self

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("title"))
        column.width = 360
        tableView.addTableColumn(column)

        scrollView.documentView = tableView
        contentView.addSubview(scrollView)

        window.contentView = contentView

        // Handle key events
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            return self?.handleKeyDown(event)
        }
    }

    private func handleKeyDown(_ event: NSEvent) -> NSEvent? {
        // Escape to close
        if event.keyCode == 53 {
            NSApp.terminate(nil)
            return nil
        }

        // Enter to select current row
        if event.keyCode == 36 {
            selectCurrentRow()
            return nil
        }

        // Home row keys for quick selection
        let keys = ["a", "s", "d", "f", "g"]
        if let chars = event.charactersIgnoringModifiers,
           let index = keys.firstIndex(of: chars.lowercased()) {
            if index < windows.count {
                selectWindow(at: index)
            }
            return nil
        }

        // Up/Down arrows
        if event.keyCode == 126 { // Up
            let newRow = max(0, tableView.selectedRow - 1)
            tableView.selectRowIndexes(IndexSet(integer: newRow), byExtendingSelection: false)
            return nil
        }
        if event.keyCode == 125 { // Down
            let newRow = min(windows.count - 1, tableView.selectedRow + 1)
            tableView.selectRowIndexes(IndexSet(integer: newRow), byExtendingSelection: false)
            return nil
        }

        return event
    }

    @objc private func rowDoubleClicked() {
        selectCurrentRow()
    }

    private func selectCurrentRow() {
        let row = tableView.selectedRow
        if row >= 0 && row < windows.count {
            selectWindow(at: row)
        } else if windows.count > 0 {
            selectWindow(at: 0)
        }
    }

    private func selectWindow(at index: Int) {
        focusWindow(windows[index])
        NSApp.terminate(nil)
    }
}

extension PickerWindowController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return windows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTextField(labelWithString: "")
        let keys = ["a", "s", "d", "f", "g"]
        let shortcut = row < keys.count ? "\(keys[row]). " : "   "
        cell.stringValue = shortcut + windows[row].title
        cell.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        return cell
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 24
    }
}

// MARK: - Main

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let windows = getGhosttyWindows().sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }

if windows.isEmpty {
    // No Ghostty windows, just exit
    exit(0)
}

if windows.count == 1 {
    // Only one window, just focus it
    focusWindow(windows[0])
    exit(0)
}

let controller = PickerWindowController(windows: windows)
controller.showWindow(nil)
app.activate(ignoringOtherApps: true)
app.run()
