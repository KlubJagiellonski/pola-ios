
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
