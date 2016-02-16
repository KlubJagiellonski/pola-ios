#import <Foundation/Foundation.h>


@interface BPAboutWebViewController : UIViewController <UIWebViewDelegate>

@property (copy, nonatomic, readonly) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end