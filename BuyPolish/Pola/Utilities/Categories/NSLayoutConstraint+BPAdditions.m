#import "NSLayoutConstraint+BPAdditions.h"

@implementation NSLayoutConstraint (BPAdditions)

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats views:(NSDictionary *)views {
    return [self constraintsWithVisualFormats:formats metrics:nil views:views];
}

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    return [self constraintsWithVisualFormats:formats options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:views];
}

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views {
    NSMutableArray *constraints = [NSMutableArray array];
    [formats enumerateObjectsUsingBlock:^(NSString *format, NSUInteger idx, BOOL *stop) {
        NSArray *formatConstraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views];
        [constraints addObjectsFromArray:formatConstraints];
    }];
    return constraints;
}

@end
