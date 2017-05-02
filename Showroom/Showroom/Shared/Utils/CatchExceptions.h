#import <Foundation/Foundation.h>

@interface CatchExceptions : NSObject

+ (BOOL)catchException:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end
