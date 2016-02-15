
#import "BPAppDelegate.h"
#import "JSObjection.h"
#import "BPObjectionModule.h"
#import "BPRootViewController.h"
#import "iOSHierarchyViewer.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AVFoundation/AVFoundation.h>


@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[CrashlyticsKit]];

    [self configureObjection];

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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [iOSHierarchyViewer start];

    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Privacy Title", @"Brak dostępu do kamery")
                                                            message:NSLocalizedString(@"Camer Privacy Description", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                  otherButtonTitles:NSLocalizedString(@"Settings", @"Ustawienia"), nil];
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
