#import "BPObjectionModule.h"
#import "BPAPIAccessor.h"
#import "BPTaskRunner.h"
#import <Pola-Swift.h>

@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self bindClass:[BPAPIAccessor class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[BPTaskRunner class] inScope:JSObjectionScopeSingleton];
    [self
         bindBlock:^id(JSObjectionInjector *context) {
             return [[EANBarcodeValidator alloc] init];
         }
        toProtocol:@protocol(BarcodeValidator)];
}

@end
