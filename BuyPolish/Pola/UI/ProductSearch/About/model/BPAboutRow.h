#import <Foundation/Foundation.h>


@interface BPAboutRow : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic) SEL action;

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action;


@end