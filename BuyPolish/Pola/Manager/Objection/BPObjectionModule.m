#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPProductManager.h"
#import "BPTaskRunner.h"
#import "BPCameraSessionManager.h"
#import "BPProductImageManager.h"
#import "BPReportManager.h"


@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPProductManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPCameraSessionManager class] inScope:JSObjectionScopeNormal];
    [self bindClass:[BPProductImageManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPReportManager class] inScope:JSObjectionScopeSingleton];
}

@end