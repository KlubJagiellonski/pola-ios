#import <Foundation/Foundation.h>


@interface BPAboutWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly, copy) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end