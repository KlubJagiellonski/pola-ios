#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPAboutWebViewController : UIViewController <UIWebViewDelegate>

@property (copy, nonatomic, readonly) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
