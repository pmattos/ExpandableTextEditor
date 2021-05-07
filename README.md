# ExpandableTextEditor

This project provides a sample SwiftUI based integration for [TextExpander SDK][TextExpander].

The SDK integration is provided by the custom [`ExpandableTextView`][ExpandableTextView] SwiftUI view. This provides a reusable, (almost) self-contained component to quickly support the TextExpander SDK in any SwiftUI based app.

This view wraps a `UITextView`, providing all expected multi-line text editing capabilities.  

The sample app shows two `ExpandableTextEditor` working side by side plus some global settings, as demonstrated by the video below:



## Future Ideas

In the future, we could extend this in the following ways:

* Expose this as a proper Swift Package framework around the aforementioned `ExpandableTextEditor`.
* Support for rich text editing
* Improve the `ExpandableTextEditor` API, providing per view settings such as: turning off snippets expansion; turning off fill-in support; etc.


[TextExpander]: https://github.com/SmileSoftware/TextExpanderTouchSDK/blob/master/README.md
[ExpandableTextView]: https://github.com/pmattos/ExpandableTextEditor/blob/main/ExpandableTextView/ExpandableTextEditor.swift
