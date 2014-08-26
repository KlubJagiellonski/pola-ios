#import <Foundation/Foundation.h>


@interface NSLayoutConstraint (BPAdditions)

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end