#import "BPObjectionModule.h"
#import <Pola-Swift.h>

@implementation BPObjectionModule

- (void)configure {
    [super configure];

    [self
         bindBlock:^id(JSObjectionInjector *context) {
             return [[EANBarcodeValidator alloc] init];
         }
        toProtocol:@protocol(BarcodeValidator)];
}

@end
