
#import "BPAppDelegate.h"
#import "JSObjection.h"
#import "BPObjectionModule.h"
#import "BPRootViewController.h"
#import "BPTheme.h"
#import "iOSHierarchyViewer.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AVFoundation/AVFoundation.h>


@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[CrashlyticsKit]];

    [self configureObjection];

    [self applyAppearance];

    JSObjectionInjector *injector = [JSObjection defaultInjector];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = injector[[BPRootViewController class]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([UIApplicationShortcutItem class]) {
        UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if (shortcutItem) {
            [self handleShortcutItem:shortcutItem];
        }
    }
    
    return YES;
}

- (void)configureObjection {
    JSObjectionInjector *defaultInjector = [JSObjection createInjectorWithModulesArray:@[
        [BPObjectionModule new],
    ]];
    [JSObjection setDefaultInjector:defaultInjector];
}

- (void)applyAppearance {
    [[UINavigationBar appearance] setBarTintColor:[BPTheme mediumBackgroundColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [BPTheme titleFont]}];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [iOSHierarchyViewer start];

    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Privacy Title", nil)
                                                            message:NSLocalizedString(@"Camer Privacy Description", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Settings", nil), nil];
        [alertView show];
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    completionHandler([self handleShortcutItem:shortcutItem]);
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)item {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *scanType = [NSString stringWithFormat:@"%@.ScanCode", bundleIdentifier];
    NSString *writeType = [NSString stringWithFormat:@"%@.WriteCode", bundleIdentifier];
    BPRootViewController *rootViewController = (BPRootViewController *) self.window.rootViewController;
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
