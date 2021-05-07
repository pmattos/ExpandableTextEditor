//
//  ContentView.swift
//  ExpandableTextView
//

import SwiftUI

/// The top-level view with 2 text views.
struct ContentView: View {
    @State private var firstText: String = "First Text\n"
    @State private var secondText: String = "Second Text\n"

    var body: some View {
        VStack {
            ExpandableTextView(text: $firstText)
                .font(.title3)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .border(Color.primary, width: 0.5)
                .padding()
            ExpandableTextView(text: $secondText)
                .font(.title3)
                .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .border(Color.primary, width: 0.5)
                .padding()
            Spacer()
            TextExpanderSettingsView()
        }
    }
}

struct TextExpanderSettingsView: View {
    @ObservedObject private var textExpanderStatus = TextExpanderStatus.shared

    var body: some View {
        Form {
            Section(header: Text("Text Expander")) {
                Button("Sync Snippets") {
                    ExpandableTextView.syncSnippets()
                }
                Button("Clear Snippets") {
                    ExpandableTextView.clearSnippets()
                }

                Toggle("Snippets Fill-in Support", isOn: $textExpanderStatus.fillInEnabled)
             
                Button("Open TextExpander") {
                    openTextExpanderApp()
                }
            }
        }
    }
    
    private func openTextExpanderApp() {
        if let appURL = URL(string: "textexpander://") {
            UIApplication.shared.open(appURL)
        }
        // Remove focus from text view, if any.
        UIResponder.firstResponder?.resignFirstResponder()
    }
    
    init() {
        // Simple hack to improve `Form` style a bit ;)
        // (ie, the underlying view for a `Form` is a `UITableView`).
        UITableView.appearance().backgroundColor = .clear
    }
}

// MARK: - Simple UI Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
