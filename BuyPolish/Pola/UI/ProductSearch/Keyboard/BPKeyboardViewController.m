#import "BPKeyboardViewController.h"
#import "BPKeyboardTextView.h"
#import "BPKeyboardView.h"
#import "NSString+BPUtilities.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BPKeyboardViewController () <BPKeyboardViewDelegate>
@end

@implementation BPKeyboardViewController

- (void)loadView {
    self.view = [BPKeyboardView new];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.castView.delegate = self;

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
}

- (BOOL)isPresented {
    return self.view.superview != nil;
}

#pragma mark - BPKeyboardViewDelegate

- (void)keyboardView:(BPKeyboardView *)keyboardView didConfirmWithCode:(NSString *)code {
    AudioServicesPlaySystemSound(1104);
    if (![code isValidBarcode]) {
        [self.castView showErrorMessage];
        return;
    }
    [self.delegate keyboardViewController:self didConfirmWithCode:code];
}

- (void)keyboardView:(BPKeyboardView *)keyboardView didChangedCode:(NSString *)code {
    [self.castView hideErrorMessage];
    AudioServicesPlaySystemSound(1104);
}

#pragma mark - Utitlites

- (BPKeyboardView *)castView {
    return (BPKeyboardView *)self.view;
}

@end
