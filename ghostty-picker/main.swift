import Cocoa
import ApplicationServices

let ghosttyBundleId = "com.mitchellh.ghostty"

struct GhosttyWindow {
    let title: String
    let axElement: AXUIElement

    var slotNumber: Int? {
        if title.hasPrefix("Ghostty "),
           let num = Int(title.dropFirst(8)),
           num >= 1 && num <= 5 {
            return num
        }
        return nil
    }
}

func getGhosttyWindows() -> [GhosttyWindow] {
    guard let ghostty = NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == ghosttyBundleId }) else {
        return []
    }

    let appRef = AXUIElementCreateApplication(ghostty.processIdentifier)
    var windowsRef: CFTypeRef?
    AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &windowsRef)

    guard let windows = windowsRef as? [AXUIElement] else { return [] }

    return windows.map { window in
        var titleRef: CFTypeRef?
        AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
        return GhosttyWindow(title: (titleRef as? String) ?? "Untitled", axElement: window)
    }
}

func focusWindow(_ window: GhosttyWindow) {
    AXUIElementPerformAction(window.axElement, kAXRaiseAction as CFString)
    NSWorkspace.shared.runningApplications.first { $0.bundleIdentifier == ghosttyBundleId }?.activate()
}

// MARK: - CLI Commands

func cmdSwitch(_ slot: Int) {
    let windows = getGhosttyWindows()
    guard let window = windows.first(where: { $0.slotNumber == slot }) else {
        fputs("No window found for slot \(slot)\n", stderr)
        exit(1)
    }
    focusWindow(window)
}

func cmdList() {
    let windows = getGhosttyWindows()

    for slot in 1...5 {
        let status = windows.contains { $0.slotNumber == slot } ? "+" : "-"
        print("\(slot). [\(status)]")
    }

    let other = windows.filter { $0.slotNumber == nil }
    if !other.isEmpty {
        print("\nOther windows:")
        for window in other {
            print("   \(window.title)")
        }
    }
}

// MARK: - Picker UI

class PickerWindowController: NSWindowController, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    private var orderedWindows: [GhosttyWindow]
    private var tableView: NSTableView!

    init(windows: [GhosttyWindow]) {
        let numbered = windows.filter { $0.slotNumber != nil }.sorted { $0.slotNumber! < $1.slotNumber! }
        let unnumbered = windows.filter { $0.slotNumber == nil }
        self.orderedWindows = numbered + unnumbered

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "Ghostty Windows"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.center()
        window.level = .floating

        super.init(window: window)
        window.delegate = self
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        guard let window = self.window else { return }

        let scrollView = NSScrollView(frame: NSRect(x: 12, y: 12, width: 376, height: 276))
        scrollView.hasVerticalScroller = true
        scrollView.autoresizingMask = [.width, .height]

        tableView = NSTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.headerView = nil
        tableView.doubleAction = #selector(rowDoubleClicked)
        tableView.target = self

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("title"))
        column.width = 360
        tableView.addTableColumn(column)

        scrollView.documentView = tableView
        window.contentView?.addSubview(scrollView)

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }
    }

    private func handleKeyDown(_ event: NSEvent) -> NSEvent? {
        switch event.keyCode {
        case 53: // Escape
            NSApp.terminate(nil)
        case 36: // Enter
            selectWindow(at: max(0, tableView.selectedRow))
        case 126: // Up
            tableView.selectRowIndexes(IndexSet(integer: max(0, tableView.selectedRow - 1)), byExtendingSelection: false)
        case 125: // Down
            tableView.selectRowIndexes(IndexSet(integer: min(orderedWindows.count - 1, tableView.selectedRow + 1)), byExtendingSelection: false)
        default:
            if let chars = event.charactersIgnoringModifiers,
               let num = Int(chars), num >= 1 && num <= 5,
               let idx = orderedWindows.firstIndex(where: { $0.slotNumber == num }) {
                selectWindow(at: idx)
            }
            return event
        }
        return nil
    }

    @objc private func rowDoubleClicked() {
        if tableView.clickedRow >= 0 {
            selectWindow(at: tableView.clickedRow)
        }
    }

    private func selectWindow(at index: Int) {
        guard index >= 0 && index < orderedWindows.count else { return }
        focusWindow(orderedWindows[index])
        NSApp.terminate(nil)
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.terminate(nil)
    }

    func numberOfRows(in tableView: NSTableView) -> Int { orderedWindows.count }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let window = orderedWindows[row]
        let prefix = window.slotNumber.map { "\($0). " } ?? "   "
        let cell = NSTextField(labelWithString: prefix + window.title)
        cell.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        return cell
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat { 24 }
}

// MARK: - Main

let args = CommandLine.arguments

if args.count > 1 {
    switch args[1] {
    case "switch":
        guard args.count > 2, let slot = Int(args[2]), slot >= 1 && slot <= 5 else {
            fputs("Usage: ghostty-picker switch N (where N is 1-5)\n", stderr)
            exit(1)
        }
        cmdSwitch(slot)
    case "list":
        cmdList()
    case "help", "-h", "--help":
        print("Usage: ghostty-picker [switch N | list]")
    default:
        fputs("Unknown command: \(args[1])\n", stderr)
        exit(1)
    }
    exit(0)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let windows = getGhosttyWindows()

if windows.count <= 1 {
    if let window = windows.first { focusWindow(window) }
    exit(0)
}

let controller = PickerWindowController(windows: windows)
controller.showWindow(nil)
app.activate(ignoringOtherApps: true)
app.run()
