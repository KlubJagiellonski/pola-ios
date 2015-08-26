#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPProductManager.h"
#import "BPTaskRunner.h"
#import "BPDeviceManager.h"


@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPDeviceManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPProductManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
}

@end