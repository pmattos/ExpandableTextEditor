//
//  SwiftWorkarounds.m
//  ExpandableTextView
//

#import "SwiftWorkarounds.h"
#import <TextExpander/TextExpander.h>
#import <notify.h>

@implementation SwiftWorkarounds

static int CustomKeyboardWillAppearToken = 0;

+ (void)disableCustomKeyboardExpansion {
    notify_register_dispatch("com.smileonmymac.tetouch.keyboard.viewWillAppear",
                             &CustomKeyboardWillAppearToken,
                             dispatch_get_main_queue(), ^(int t) {
                                 [SMTEDelegateController setCustomKeyboardExpansionEnabled:NO];
                             });
}

@end
