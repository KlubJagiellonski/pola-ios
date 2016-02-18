#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BPAboutRowStyle) {
    BPAboutRowStyleSingle,
    BPAboutRowStyleDouble
};

@interface BPAboutRow : NSObject

@property (copy, nonatomic) NSString *title;
@property (nonatomic) SEL action;
@property (nonatomic) BPAboutRowStyle style;

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action;
+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action;


@end