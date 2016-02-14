//
//  NSDictionary+Parsing.h
//  Pola
//
//  Created by Arkadiusz Banaś on 14/02/16.
//  Copyright © 2016 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Parsing)

- (NSString *)nilOrStringForKey:(NSString *)key;
- (NSNumber *)nilOrNumberForKey:(NSString *)key;

@end
