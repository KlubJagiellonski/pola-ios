
#import "BPAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <Pola-Swift.h>

@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [BPAnalyticsHelper configure];

    [self applyAppearance];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[BPRootViewController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if ([NSProcessInfo.processInfo.arguments containsObject:@"--disableAnimations"]) {
        self.window.layer.speed = 0.0f;
        [UIView setAnimationsEnabled:NO];
    }

    if ([UIApplicationShortcutItem class]) {
        UIApplicationShortcutItem *shortcutItem =
            [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (shortcutItem) {
            [self handleShortcutItem:shortcutItem];
        }
    }

    return YES;
}

- (void)applyAppearance {
    [[UINavigationBar appearance] setBarTintColor:[BPTheme mediumBackgroundColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName: [BPTheme titleFont] }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Privacy Title", nil)
                                       message:NSLocalizedString(@"Camera Privacy Scan Barcode Description", nil)
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                             otherButtonTitles:NSLocalizedString(@"Settings", nil), nil];
        [alertView show];
    }
}

- (void)application:(UIApplication *)application
    performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
               completionHandler:(void (^)(BOOL))completionHandler {
    completionHandler([self handleShortcutItem:shortcutItem]);
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)item {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *scanType = [NSString stringWithFormat:@"%@.ScanCode", bundleIdentifier];
    NSString *writeType = [NSString stringWithFormat:@"%@.WriteCode", bundleIdentifier];
    BPRootViewController *rootViewController = (BPRootViewController *)self.window.rootViewController;
    if ([item.type isEqualToString:scanType]) {
        [rootViewController showScanCodeView];
        return YES;
    } else if ([item.type isEqualToString:writeType]) {
        [rootViewController showWriteCodeView];
        return YES;
    }
    return NO;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
