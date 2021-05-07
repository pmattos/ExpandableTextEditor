//
//  ExpandableTextViewApp.swift
//  ExpandableTextView
//

import SwiftUI
import TextExpander
import os.log

/// The app entry point.
@main
struct ExpandableTextViewApp: App {
    static let appName = "ExpandableTextView"
    static let appURLScheme = "xtextview-demo"

    /// Corresponding app delegate.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    os_log("onOpenURL: %@", url.description)
                    ExpandableTextView.handleOpenURL(url)
                }
        }
    }
}

// MARK: - Classic UIApplicationDelegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        os_log("didFinishLaunchingWithOptions")
        SwiftWorkarounds.disableCustomKeyboardExpansion()
        return true
    }
}

