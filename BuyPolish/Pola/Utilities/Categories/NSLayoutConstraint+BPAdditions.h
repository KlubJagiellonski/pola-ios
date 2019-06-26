#import <Foundation/Foundation.h>

@interface NSLayoutConstraint (BPAdditions)

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats views:(NSDictionary *)views;
+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats metrics:(NSDictionary *)metrics views:(NSDictionary *)views;
+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end
