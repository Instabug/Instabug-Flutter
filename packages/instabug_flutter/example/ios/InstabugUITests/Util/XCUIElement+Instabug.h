#import <XCTest/XCTest.h>

@interface XCUIElement (Instabug)

- (void)scrollDownAndTap;
- (void)scrollUpAndTap;
- (void)closeKeyboard;
- (void)forceTap;
- (void)assertExistsWithTimeout:(NSTimeInterval)timeout;
- (void)assertDoesNotExist;

@end
