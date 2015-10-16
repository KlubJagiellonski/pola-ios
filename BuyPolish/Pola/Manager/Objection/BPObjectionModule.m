#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPProductManager.h"
#import "BPTaskRunner.h"
#import "BPDeviceManager.h"
#import "BPCameraSessionManager.h"
#import "BPProductImageManager.h"


@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPDeviceManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPProductManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPCameraSessionManager class] inScope:JSObjectionScopeNormal];
    [self bindClass:[BPProductImageManager class] inScope:JSObjectionScopeSingleton];
}

@end