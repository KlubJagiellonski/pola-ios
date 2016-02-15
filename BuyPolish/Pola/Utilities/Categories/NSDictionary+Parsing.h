
#import <Foundation/Foundation.h>

@interface NSDictionary (Parsing)

- (NSString *)nilOrStringForKey:(NSString *)key;
- (NSNumber *)nilOrNumberForKey:(NSString *)key;

@end
