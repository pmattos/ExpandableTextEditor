//
//  TextExpanderStatus.swift
//  ExpandableTextView
//

import TextExpander
import os.log

/// Tracks TextExpander general status.
final class TextExpanderStatus: ObservableObject {
    @Published fileprivate(set) var expansionEnabled: Bool = false
    @Published fileprivate(set) var snippetsCount: UInt = 0
    @Published var fillInEnabled: Bool = true
    
    static let shared = TextExpanderStatus()
    
    private init() {
        update()
    }
    
    func update() {
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
