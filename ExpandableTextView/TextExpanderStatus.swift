//
//  TextExpanderStatus.swift
//  ExpandableTextView
//

import TextExpander
import os.log

/// Model tracking TextExpander general status.
final class TextExpanderStatus: ObservableObject {
    @Published var expansionEnabled: Bool = false
    @Published var snippetsCount: UInt = 0
    @Published var fillInEnabled: Bool = true
    
    static let shared = TextExpanderStatus()
    
    private init() {
        update()
    }
    
    func update() {
        expansionEnabled = SMTEDelegateController.expansionEnabled()
        
        // TODO: Add support for snippets count, etc.
        /*
        DispatchQueue.global(qos: .userInitiated).async {
            var snippetsCount: UInt = 0
            do {
                try SMTEDelegateController
                    .expansionStatusForceLoad(true, snippetCount: &snippetsCount, load: nil)
            } catch {
                os_log(.error, "expansionStatusForceLoad FAILED: %@",
                       error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.snippetsCount = snippetsCount
            }
        }
        */
    }
}
