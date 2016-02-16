#import <Foundation/Foundation.h>


@interface BPAboutRow : NSObject

@property(copy, nonatomic) NSString *title;
@property(nonatomic) SEL action;

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action;


@end