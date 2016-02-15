#import <Foundation/Foundation.h>


@interface BPAboutWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end