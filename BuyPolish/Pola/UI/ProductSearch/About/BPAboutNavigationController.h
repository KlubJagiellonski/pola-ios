#import <Foundation/Foundation.h>
#import "BPAboutViewController.h"

@class BPAboutNavigationController;

@protocol BPInfoNavigationControllerDelegate <NSObject>
- (void)infoCancelled:(BPAboutNavigationController *)infoNavigationController;
@end

@interface BPAboutNavigationController : UINavigationController <BPInfoViewControllerDelegate>

@property(weak, nonatomic) id <BPInfoNavigationControllerDelegate> infoDelegate;

@end
