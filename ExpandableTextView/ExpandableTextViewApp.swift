//
//  ExpandableTextViewApp.swift
//  ExpandableTextView
//

import SwiftUI
import TextExpander

/// The app entry point.
@main
struct ExpandableTextViewApp: App {
    static let appName = "ExpandableTextView"
    static let appURLScheme = "xtextview-demo"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("onOpenURL:", url)
                    ExpandableTextEditor.handleOpenURL(url)
                }
        }
    }
}
