#import "XCUIElement+Instabug.h"

@implementation XCUIElement (Instabug)

- (void)scrollAndTap {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    while (!self.isHittable) {
        [app swipeUp];
    }

    sleep(1);
    [self tap];
}

- (void)closeKeyboard {
    [self typeText:@"\n"];
}

@end
