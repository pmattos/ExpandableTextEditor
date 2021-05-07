//
//  SMSwiftWorkarounds.h
//  ExpandableTextView
//

#import <Foundation/Foundation.h>

@interface SwiftWorkarounds : NSObject

/// Disable expansion by the custom keyboard, as we implement the SDK and so can do more
/// than the custom keyboard (i.e., work with system keyboards, support rich text, support
/// robust x-callback-url UI for fill-ins).
+ (void)disableCustomKeyboardExpansion;

@end
