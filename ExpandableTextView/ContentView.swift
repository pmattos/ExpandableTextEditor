//
//  ContentView.swift
//  ExpandableTextView
//

import SwiftUI

/// The top-level view.
struct ContentView: View {
    @State private var text: String = "Hello world!\n"
    
    var body: some View {
        VStack {
            ExpandableTextView(text: $text)
                .font(.title2)
                .padding(10)
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
                Button("Sync Snippets (\(textExpanderStatus.snippetsCount))") {
                    ExpandableTextView.syncSnippets()
                }
                Button("Clear Snippets") {
                    ExpandableTextView.clearSnippets()
                }
                Toggle("Snippets Fill-in Support", isOn: $textExpanderStatus.fillInEnabled)
            }
        }
    }
    
    init() {
        // Simple hack to improve `Form` style a bit ;)
        // (ie, the underlying view for a `Form` is a `UITableView`).
        UITableView.appearance().backgroundColor = .clear
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
