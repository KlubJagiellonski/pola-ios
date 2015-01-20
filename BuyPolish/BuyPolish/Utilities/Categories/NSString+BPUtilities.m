#import "NSString+BPUtilities.h"


@implementation NSString (BPUtilities)

- (BOOL)isValidBarcode {
    int length = self.length;
    if (length == 8) {
        return [self isValidEAN8];
    } else if (length == 13) {
        return [self isValidEAN13];
    }
    return NO;
}

- (BOOL)isValidEAN13 {
    int check = [self intForDigitAt:7];
    int val = (10 -
        (([self intForDigitAt:1] + [self intForDigitAt:3] + [self intForDigitAt:5] +
            ([self intForDigitAt:0] + [self intForDigitAt:2] + [self intForDigitAt:4] + [self intForDigitAt:6]) *
                3) % 10)) % 10;

    return check == val;
}

- (BOOL)isValidEAN8 {
    int check = [self intForDigitAt:12];
    int val = (10 -
        (([self intForDigitAt:0] + [self intForDigitAt:2] + [self intForDigitAt:4] + [self intForDigitAt:6] + [self intForDigitAt:8] + [self intForDigitAt:10] +
            ([self intForDigitAt:1] + [self intForDigitAt:3] + [self intForDigitAt:5] + [self intForDigitAt:7] + [self intForDigitAt:9] + [self intForDigitAt:11]) *
                3) % 10)) % 10;

    return check == val;
}

- (int)intForDigitAt:(NSUInteger)index {
    unichar ch = [self characterAtIndex:index];
    if (ch >= '0' && ch <= '9') {
        return ch - '0';
    } else
        return 0;
}

@end