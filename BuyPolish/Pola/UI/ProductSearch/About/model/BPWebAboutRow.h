#import <Foundation/Foundation.h>
#import "BPAboutRow.h"

@interface BPWebAboutRow : BPAboutRow

@property(copy, nonatomic) NSString *url;

@property(copy, nonatomic) NSString *analyticsName;

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName;

@end
