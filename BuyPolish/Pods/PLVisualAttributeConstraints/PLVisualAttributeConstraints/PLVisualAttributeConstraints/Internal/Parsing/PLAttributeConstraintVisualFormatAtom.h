/*

 Copyright (c) 2013, Kamil Jaworski, Polidea
 All rights reserved.

 mailto: kamil.jaworski@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY KAMIL JAWORSKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KAMIL JAWORSKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PLAtomType){     // [[ stringData ]]
    PLAtomTypeEndOfInput,                   // nil
    PLAtomTypeError,                        // error message
    PLAtomTypePlus,                         // '+'
    PLAtomTypeMinus,                        // '-'
    PLAtomTypeAsterisk,                     // '*'
    PLAtomTypeFloatingPointNumber,          // number as string (f.e. '23.45', '23', '56.')
    PLAtomTypeRelationEqual,                // '=='
    PLAtomTypeRelationLessOrEqual,          // '<='
    PLAtomTypeRelationGreaterOrEqual,       // '>='
    PLAtomTypeIdentifier,                   // identifier as string (f.e. 'myControl')
    PLAtomTypeDot,                          // '.'
    PLAtomTypeWhitespace                    // read whitespaces (f.e. '  ')
};

@interface PLAttributeConstraintVisualFormatAtom : NSObject

@property(nonatomic, readonly) PLAtomType atomType;
@property(nonatomic, readonly) NSString *stringData;
@property(nonatomic, readonly) NSUInteger startIndex;

+ (NSString *)atomNameForAtomType:(PLAtomType)type;
- (id)initWithAtomType:(PLAtomType)atomType stringData:(NSString *)stringData startIndex:(NSUInteger)startIndex;
+ (id)atomWithType:(PLAtomType)atomType stringData:(NSString *)stringData startIndex:(NSUInteger)startIndex;

@end
