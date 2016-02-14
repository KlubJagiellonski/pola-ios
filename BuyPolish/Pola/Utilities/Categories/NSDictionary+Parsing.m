//
//  NSDictionary+Parsing.m
//  Pola
//
//  Created by Arkadiusz Banaś on 14/02/16.
//  Copyright © 2016 PJMS. All rights reserved.
//

#import "NSDictionary+Parsing.h"

@implementation NSDictionary (Parsing)

#pragma mark - Public

- (NSString *)nilOrStringForKey:(NSString *)key{
    return [self validateObjectForKey:key andClass:[NSString class]];
}

- (NSNumber *)nilOrNumberForKey:(NSString *)key{
    return [self validateObjectForKey:key andClass:[NSNumber class]];
}

#pragma mark - Private

- (id)validateObjectForKey:(NSString *)key andClass:(Class)class {
    id obj = [self objectForKey:key];
    BOOL isCorrectObject = obj != nil && [obj isKindOfClass:class];
    return isCorrectObject ? obj : nil;
}

@end
