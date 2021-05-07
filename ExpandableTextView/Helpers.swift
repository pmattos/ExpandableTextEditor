//
//  Helpers.swift
//  ExpandableTextView
//

import UIKit

extension UIResponder {
    private weak static var currentFirstResponder: UIResponder? = nil
    
    /// Returns the current 1st responder, if any.
    public static var firstResponder: UIResponder? {
        currentFirstResponder = nil
        UIApplication.shared
            .sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return currentFirstResponder
    }
    
    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder.currentFirstResponder = self
    }
}
