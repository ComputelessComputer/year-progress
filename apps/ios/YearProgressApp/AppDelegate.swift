import Cocoa
import ServiceManagement

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var currentMode: ProgressMode = .year
    private var updateTimer: Timer?
    private let launchAtLoginKey = "LaunchAtLogin"
    private let customEndDateKey = "CustomEndDate"
    private var yearMenuItem: NSMenuItem?
    private var monthMenuItem: NSMenuItem?
    private var dayMenuItem: NSMenuItem?
    private var weekMenuItem: NSMenuItem?
    private var workWeekMenuItem: NSMenuItem?
    private var customMenuItem: NSMenuItem?
    
    private var customEndDate: Date?

    private enum ProgressMode: CaseIterable {
        case year, month, week, workWeek, day, custom
        
        var title: String {
            switch self {
            case .year: return "of yyyy"
            case .month: return "of MMMM"
            case .week: return "of Week"
            case .workWeek: return "of Work Week"
            case .day: return "of Today"
            case .custom: return "Custom"
            }
        }
        
        mutating func next() {
            let currentIndex = ProgressMode.allCases.firstIndex(of: self)!
            self = ProgressMode.allCases[(currentIndex + 1) % ProgressMode.allCases.count]
        }
    }

    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        if let endDate = UserDefaults.standard.object(forKey: customEndDateKey) as? Date {
            customEndDate = endDate
        }
        
        setupStatusItem()
        startTimer()
        updateProgress()
        
        
        if UserDefaults.standard.bool(forKey: launchAtLoginKey) {
            do {
                try SMAppService.mainApp.register()
            } catch {
                print("Failed to register login item: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            button.title = "Loading..."
            button.target = self
            button.action = #selector(statusBarButtonClicked(_:))
        }
        
        let menu = NSMenu()
        
        yearMenuItem = NSMenuItem(title: "Year Progress", action: #selector(selectYearMode), keyEquivalent: "")
        monthMenuItem = NSMenuItem(title: "Month Progress", action: #selector(selectMonthMode), keyEquivalent: "")
        weekMenuItem = NSMenuItem(title: "Week Progress", action: #selector(selectWeekMode), keyEquivalent: "")
        workWeekMenuItem = NSMenuItem(title: "Work Week Progress", action: #selector(selectWorkWeekMode), keyEquivalent: "")
        dayMenuItem = NSMenuItem(title: "Day Progress", action: #selector(selectDayMode), keyEquivalent: "")
        customMenuItem = NSMenuItem(title: "Custom Date Progress", action: #selector(selectCustomMode), keyEquivalent: "")
        
        if let yearItem = yearMenuItem, let monthItem = monthMenuItem, 
           let weekItem = weekMenuItem, let workWeekItem = workWeekMenuItem,
           let dayItem = dayMenuItem, let customItem = customMenuItem {
            menu.addItem(yearItem)
            menu.addItem(monthItem)
            menu.addItem(weekItem)
            menu.addItem(workWeekItem)
            menu.addItem(dayItem)
            menu.addItem(customItem)
        }
        
        menu.addItem(NSMenuItem.separator())
        
        
        let configureCustomItem = NSMenuItem(title: "Configure Custom End Date...", action: #selector(configureCustomDates), keyEquivalent: "")
        menu.addItem(configureCustomItem)
        
        
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.state = UserDefaults.standard.bool(forKey: launchAtLoginKey) ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        statusItem.menu = menu
        
        
        updateMenuCheckmarks()
    }
    
    @objc private func selectYearMode() {
        currentMode = .year
        updateMenuCheckmarks()
        updateProgress()
    }
    
    @objc private func selectMonthMode() {
        currentMode = .month
        updateMenuCheckmarks()
        updateProgress()
    }
    
    @objc private func selectWeekMode() {
        currentMode = .week
        updateMenuCheckmarks()
        updateProgress()
    }
    
    @objc private func selectWorkWeekMode() {
        currentMode = .workWeek
        updateMenuCheckmarks()
        updateProgress()
    }
    
    @objc private func selectDayMode() {
        currentMode = .day
        updateMenuCheckmarks()
        updateProgress()
    }
    
    @objc private func selectCustomMode() {
        if let _ = customEndDate {
            currentMode = .custom
            updateMenuCheckmarks()
            updateProgress()
        } else {
            configureCustomDates()
        }
    }
    
    @objc private func configureCustomDates() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Configure Custom End Date"
        window.center()
        
        let contentView = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 150))
        
        let endLabel = NSTextField(labelWithString: "End Date:")
        endLabel.frame = NSRect(x: 20, y: 100, width: 100, height: 20)
        contentView.addSubview(endLabel)
        
        let endDatePicker = NSDatePicker()
        endDatePicker.datePickerStyle = .textField
        endDatePicker.datePickerMode = .single
        endDatePicker.frame = NSRect(x: 130, y: 100, width: 200, height: 20)
        if let endDate = customEndDate {
            endDatePicker.dateValue = endDate
        } else {
            endDatePicker.dateValue = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        }
        contentView.addSubview(endDatePicker)
        
        let descLabel = NSTextField(wrappingLabelWithString: "Set an end date to track progress from today to that date.")
        descLabel.frame = NSRect(x: 20, y: 60, width: 360, height: 30)
        contentView.addSubview(descLabel)
        
        let saveButton = NSButton(title: "Save", target: nil, action: nil)
        saveButton.frame = NSRect(x: 280, y: 20, width: 100, height: 32)
        saveButton.bezelStyle = .rounded
        saveButton.keyEquivalent = "\r" 
        
        saveButton.target = self
        saveButton.action = #selector(saveCustomDates(_:))
        
        objc_setAssociatedObject(saveButton, UnsafeRawPointer(bitPattern: 2)!, endDatePicker, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(saveButton, UnsafeRawPointer(bitPattern: 3)!, window, .OBJC_ASSOCIATION_RETAIN)
        
        contentView.addSubview(saveButton)
        
        let cancelButton = NSButton(title: "Cancel", target: nil, action: nil)
        cancelButton.frame = NSRect(x: 170, y: 20, width: 100, height: 32)
        cancelButton.bezelStyle = .rounded
        cancelButton.target = self
        cancelButton.action = #selector(closeCustomDatesWindow(_:))
        objc_setAssociatedObject(cancelButton, UnsafeRawPointer(bitPattern: 3)!, window, .OBJC_ASSOCIATION_RETAIN)
        contentView.addSubview(cancelButton)
        
        window.contentView = contentView
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func saveCustomDates(_ sender: NSButton) {
        guard let endDatePicker = objc_getAssociatedObject(sender, UnsafeRawPointer(bitPattern: 2)!) as? NSDatePicker,
              let window = objc_getAssociatedObject(sender, UnsafeRawPointer(bitPattern: 3)!) as? NSWindow else {
            return
        }
        
        let endDate = endDatePicker.dateValue
        
        if Date() >= endDate {
            let alert = NSAlert()
            alert.messageText = "Invalid Date"
            alert.informativeText = "The end date must be in the future."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: window, completionHandler: nil)
            return
        }
        
        customEndDate = endDate
        
        UserDefaults.standard.set(endDate, forKey: customEndDateKey)
        
        currentMode = .custom
        updateMenuCheckmarks()
        updateProgress()
        
        window.close()
    }
    
    @objc private func closeCustomDatesWindow(_ sender: NSButton) {
        if let window = objc_getAssociatedObject(sender, UnsafeRawPointer(bitPattern: 3)!) as? NSWindow {
            window.close()
        }
    }
    
    private func startTimer() {
        updateTimer?.invalidate()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
        
        RunLoop.current.add(updateTimer!, forMode: .common)
    }

    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        currentMode.next()
        updateMenuCheckmarks()
        updateProgress()
    }
    
    private func updateProgress() {
        let calendar = Calendar.current
        let now = Date()
        
        let progress: Double
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        let dateFormatter = DateFormatter()
        
        let displayText: String
        
        switch currentMode {
        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
            let endOfYear = calendar.date(byAdding: DateComponents(year: 1), to: startOfYear)!
            progress = Double(calendar.dateComponents([.second], from: startOfYear, to: now).second!) /
                      Double(calendar.dateComponents([.second], from: startOfYear, to: endOfYear).second!) * 100
            
            dateFormatter.dateFormat = "yyyy"
            displayText = "of \(dateFormatter.string(from: now))"
            
        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
            progress = Double(calendar.dateComponents([.second], from: startOfMonth, to: now).second!) /
                      Double(calendar.dateComponents([.second], from: startOfMonth, to: endOfMonth).second!) * 100
            
            dateFormatter.dateFormat = "MMMM"
            displayText = "of \(dateFormatter.string(from: now))"
            
        case .week:
            let weekday = calendar.component(.weekday, from: now)
            let daysToSubtract = weekday - calendar.firstWeekday
            let startOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: calendar.startOfDay(for: now))!
            let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            
            progress = Double(calendar.dateComponents([.second], from: startOfWeek, to: now).second!) /
                      Double(calendar.dateComponents([.second], from: startOfWeek, to: endOfWeek).second!) * 100
            
            let weekOfYear = calendar.component(.weekOfYear, from: now)
            displayText = "Week \(weekOfYear)"
            
        case .workWeek:
            let weekday = calendar.component(.weekday, from: now)
            
            
            if weekday == 1 || weekday == 7 {  
                progress = 100.0
                displayText = "Weekend!"
            } else {
                
                var daysToSubtract = weekday - 2  
                if daysToSubtract < 0 {
                    daysToSubtract += 7
                }
                
                let startOfWorkWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: calendar.startOfDay(for: now))!
                let endOfWorkWeek = calendar.date(byAdding: .day, value: 5, to: startOfWorkWeek)!
                
                progress = Double(calendar.dateComponents([.second], from: startOfWorkWeek, to: now).second!) /
                          Double(calendar.dateComponents([.second], from: startOfWorkWeek, to: endOfWorkWeek).second!) * 100
                
                let weekOfYear = calendar.component(.weekOfYear, from: now)
                displayText = "Week \(weekOfYear)"
            }
            
        case .day:
            let startOfDay = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: now))!
            let endOfDay = calendar.date(byAdding: DateComponents(day: 1), to: startOfDay)!
            progress = Double(calendar.dateComponents([.second], from: startOfDay, to: now).second!) /
                      Double(calendar.dateComponents([.second], from: startOfDay, to: endOfDay).second!) * 100
            
            displayText = "of Today"
            
        case .custom:
            if let end = customEndDate {
                let start = Date()
                
                if start > end {
                    progress = 100
                } else {
                    progress = 0  
                }
                
                dateFormatter.dateFormat = "MMM d, yyyy"
                displayText = "until \(dateFormatter.string(from: end))"
            } else {
                progress = 0
                displayText = "Custom (not set)"
            }
        }
        
        if let button = statusItem.button {
            let roundedProgress = Int(round(progress / 5.0) * 5)
            let imageName = String(format: "gauge%02d", roundedProgress)
            
            if let originalImage = NSImage(named: imageName) {
                let resizedImage = NSImage(size: NSSize(width: 18, height: 18))
                resizedImage.lockFocus()
                originalImage.size = NSSize(width: 18, height: 18)
                originalImage.draw(in: NSRect(x: 0, y: 0, width: 18, height: 18))
                resizedImage.unlockFocus()
                resizedImage.isTemplate = true  
                
                button.image = resizedImage
                button.imagePosition = .imageLeft
            }
            
            button.title = " \(formatter.string(from: NSNumber(value: progress))!)% \(displayText)"
        }
    }
    
    private func updateMenuCheckmarks() {
        yearMenuItem?.state = currentMode == .year ? .on : .off
        monthMenuItem?.state = currentMode == .month ? .on : .off
        weekMenuItem?.state = currentMode == .week ? .on : .off
        workWeekMenuItem?.state = currentMode == .workWeek ? .on : .off
        dayMenuItem?.state = currentMode == .day ? .on : .off
        customMenuItem?.state = currentMode == .custom ? .on : .off
    }
    
    @objc private func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        do {
            if sender.state == .on {
                try SMAppService.mainApp.unregister()
                sender.state = .off
                UserDefaults.standard.set(false, forKey: launchAtLoginKey)
            } else {
                try SMAppService.mainApp.register()
                sender.state = .on
                UserDefaults.standard.set(true, forKey: launchAtLoginKey)
            }
        } catch {
            print("Failed to toggle login item: \(error.localizedDescription)")
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        updateTimer?.invalidate()
    }
}
