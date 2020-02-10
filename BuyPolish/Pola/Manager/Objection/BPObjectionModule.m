#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPTaskRunner.h"

@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
}

@end
