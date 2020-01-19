#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPCameraSessionManager.h"
#import "BPReportManager.h"
#import "BPTaskRunner.h"

@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPCameraSessionManager class] inScope:JSObjectionScopeNormal];
    [self bindClass:[BPReportManager class] inScope:JSObjectionScopeSingleton];
}

@end
