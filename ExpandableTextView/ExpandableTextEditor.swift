//
//  ExpandableTextView.swift
//  ExpandableTextView
//

import SwiftUI
import os.log
import TextExpander

/// A `UITextView` based view wrapper with built-in support
/// for TextExpander SDK features.
///
/// The following TextExpander SDK features are supported:
/// * Simple snippets expansion
/// * Fill-in for complex snippets
struct ExpandableTextEditor: UIViewRepresentable {
    @Binding private var text: String
    @Environment(\.font) private var font: Font?
    
    init(text: Binding<String>) {
        _text = text
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.autocapitalizationType = .none
        textView.font = .preferredFont(for: font)
        
        context.coordinator.setUp(textView)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(text: $text)
        Self.knownCoordinators[coordinator.identifier] = CoordinatorRef(coordinator)
        
        return coordinator
    }
    
    /// Coordinates integration with **UIKit** and **TextExpander**
    /// delegate-based communication.
    final class Coordinator: NSObject, UITextViewDelegate, SMTEFillDelegate {
        fileprivate let identifier = UUID()
        private weak var textView: UITextView?
        
        @Binding private var text: String
        fileprivate let textExpander = SMTEDelegateController()
        
        init(text: Binding<String>) {
            // Here we assign our injected Binding directly to our text
            // property (ie, `_text`), rather than assigning its wrapped value.
            _text = text
        }
        
        func setUp(_ textView: UITextView) {
            textView.delegate = textExpander
            textExpander.nextDelegate = self
            textExpander.fillCompletionScheme = ExpandableTextViewApp.appURLScheme
            textExpander.fillDelegate = self
            self.textView = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        
        func identifier(forTextArea uiTextObject: Any!) -> String! {
            guard ExpandableTextEditor.textExpanderStatus.fillInEnabled else {
                return nil
            }
            return identifier.description
        }
        
        func makeIdentifiedTextObjectFirstResponder(
            _ textIdentifier: String!,
            fillWasCanceled userCanceledFill: Bool,
            cursorPosition ioInsertionPointLocation: UnsafeMutablePointer<Int>!
        ) -> Any! {
            guard ExpandableTextEditor.textExpanderStatus.fillInEnabled,
                  let textView = textView
            else {
                return nil
            }
            
            if let cursor = ioInsertionPointLocation?.pointee,
               let pos = textView.position(from: textView.beginningOfDocument, offset: cursor) {
                textView.selectedTextRange = textView.textRange(from: pos, to: pos)
            }
            textView.becomeFirstResponder()
            return textView
        }
    }
}

// MARK: - TextExpander Integration

extension ExpandableTextEditor {
    private static let sharedTextExpander = SMTEDelegateController()
    private static var knownCoordinators: [UUID: CoordinatorRef] = [:]

    private struct CoordinatorRef {
        weak var value: Coordinator?
        
        init(_ value: Coordinator?) {
            self.value = value
        }
    }

    static func syncSnippets() {
        sharedTextExpander.getSnippetsScheme = ExpandableTextViewApp.appURLScheme
        sharedTextExpander.clientAppName = ExpandableTextViewApp.appName
        sharedTextExpander.getSnippets()
    }
    
    /// Handles the specified TextExpander URL, if compatible.
    /// Returns `true` if URL was from TextExpander.
    @discardableResult
    static func handleOpenURL(_ url: URL) -> Bool {
        // To differentiate from other URL calls the app might receives,
        // we need to examine the URL for the presence of "x-callback-url" in the URL host
        // and "/TextExpander" as the prefix of the URL path to determine whether or not
        // a given URL is a TextExpander snippet data callback to your URL scheme.
        guard url.scheme == ExpandableTextViewApp.appURLScheme,
              url.host == "x-callback-url"
        else {
            return false
        }
        
        if url.path.hasPrefix("/TextExpander") {
            // Snippets update.
            return handleGetSnippetsURL(url)
        } else {
            // Snippets fill-in.
            guard let textID = url.textID else {
                // Probably enable/disable logging only.
                return sharedTextExpander.handleFillCompletionURL(url)
            }
            let identifier = UUID(uuidString: textID)!
            let coordinator = knownCoordinators[identifier]?.value
            return coordinator?.textExpander.handleFillCompletionURL(url) ?? false
        }
    }
    
    private static func handleGetSnippetsURL(_ url: URL) -> Bool {
        var error: NSError?
        let urlWasValid = sharedTextExpander
            .handleGetSnippetsURL(url, error: &error, cancelFlag: nil)
        if let error = error {
            os_log(.error, "handleGetSnippetsURL FAILED: %@", error)
        } else {
            os_log(.info, "handleGetSnippetsURL SUCCEEDED")
            textExpanderStatus.update()
        }
        return urlWasValid
    }
    
    /// Clears fetched snippets, if any.
    static func clearSnippets() {
        SMTEDelegateController.clearSharedSnippets()
        textExpanderStatus.update()
    }
}

fileprivate extension URL {
    var textID: String? {
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = urlComponents.queryItems
        else {
            return nil
        }
        return queryItems.first {$0.name == "textID"}?.value
    }
}

// MARK: - TextExpander Settings

extension ExpandableTextEditor {
    static let textExpanderStatus = TextExpanderStatus()

    /// Tracks TextExpander general status.
    final class TextExpanderStatus: ObservableObject {
        @Published fileprivate(set) var expansionEnabled: Bool = false
        @Published fileprivate(set) var snippetsCount: UInt = 0
        @Published var fillInEnabled: Bool = true

        fileprivate init() {
            update()
        }
        
        fileprivate func update() {
            DispatchQueue.global(qos: .userInitiated).async {
                let expansionEnabled = SMTEDelegateController.expansionEnabled()
                var snippetsCount: UInt = 0
                do {
                    try SMTEDelegateController
                        .expansionStatusForceLoad(true, snippetCount: &snippetsCount, load: nil)
                } catch {
                    os_log(.error, "expansionStatusForceLoad FAILED: %@",
                           error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.expansionEnabled = expansionEnabled
                    self.snippetsCount = snippetsCount
                }
            }
        }
    }
}



/*
 
 final class FakeViewDelegate: NSObject, UITextViewDelegate {
     func textViewDidChange(_ textView: UITextView) {
         print("FakeViewDelegate...")
     }
 }



final class TextView: UITextView {
    
    override var text: String! {
        didSet {
            print("DID SET")
        }
    }
}
*/

// MARK: - Helpers

extension UIFont {
    
    /// Converts from `Font` to `UIFont`.
    /// This still does *not* support custom sizes, weights, etc.
    class func preferredFont(for font: Font?) -> UIFont {
        guard let font = font else {
            os_log(.error, "Unexpected nit font")
            return UIFont.preferredFont(forTextStyle: .body)
        }
        
        switch font {
        case .largeTitle:
            return UIFont.preferredFont(forTextStyle: .largeTitle)
        case .title:
            return UIFont.preferredFont(forTextStyle: .title1)
        case .title2:
            return UIFont.preferredFont(forTextStyle: .title2)
        case .title3:
            return UIFont.preferredFont(forTextStyle: .title3)
        case .headline:
            return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline:
            return UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout:
            return UIFont.preferredFont(forTextStyle: .callout)
        case .caption:
            return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2:
            return UIFont.preferredFont(forTextStyle: .caption2)
        case .footnote:
            return UIFont.preferredFont(forTextStyle: .footnote)
        case .body:
            return UIFont.preferredFont(forTextStyle: .body)
        default:
            os_log(.error, "Font not supported: %@", String(describing: font))
            return UIFont.preferredFont(forTextStyle: .body)
        }
    }
}


