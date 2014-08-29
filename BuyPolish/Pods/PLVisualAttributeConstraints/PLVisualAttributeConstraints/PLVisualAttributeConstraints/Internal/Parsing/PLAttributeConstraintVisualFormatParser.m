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


#import "PLAttributeConstraintVisualFormatParser.h"
#import "PLAttributeConstraintVisualFormatLexer.h"
#import "PLAttributeConstraintVisualFormatAtom.h"
#import "PLConstraintLayoutAttributeMapper.h"
#import "PLAttributeConstraintVisualFormatLexerProtocol.h"

#define PLAttributeConstraintFormatParserDebuggingLogsEnabled 0

@implementation PLAttributeConstraintVisualFormatParser {
    id <PLAttributeConstraintVisualFormatLexerProtocol> _lexer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lexer = nil;
    }
    return self;
}

- (instancetype)initWithLexer:(id <PLAttributeConstraintVisualFormatLexerProtocol>)lexer {
    self = [super init];
    if (self) {
        _lexer = lexer;
    }
    return self;
}

#pragma mark - main parsing method

- (NSLayoutConstraint *)parseConstraintWithViews:(NSDictionary *)views {

    NSAssert(_lexer, @"Trying to parse constraint but no lexer provided", nil);
    NSAssert(views, @"Trying to parse constraint but no views provided", nil);

#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Creating constraint for format: %@", _lexer.text);
#endif

    NSArray *firstControlWithAttribute = nil;
    NSArray *secondControlWithAttribute = nil;

    NSLayoutRelation relation = NSLayoutRelationEqual;

    CGFloat multiplier = 1.0f;
    CGFloat constant = 0.0f;

    [self omitWhiteSpaces];

    // First control
    firstControlWithAttribute = [self parseControlAttributeReportErrorOnFailure:YES];
    if (!firstControlWithAttribute) {
        return nil;
    }

    [self omitWhiteSpaces];

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    // Relation
    atom = [_lexer next];
    PLAtomType atomType = atom.atomType;
    if (atomType == PLAtomTypeRelationEqual || atomType == PLAtomTypeRelationLessOrEqual || atomType == PLAtomTypeRelationGreaterOrEqual) {
        relation = [self relationFromAtom:atom];
    } else {
        [self logErrorExpectedRelationAtomAndGotAtom:atom];
        return nil;
    }

    [self omitWhiteSpaces];

    // Optional second control
    secondControlWithAttribute = [self parseControlAttributeReportErrorOnFailure:NO];

    [self omitWhiteSpaces];

    BOOL noLayoutAttributeOnRightSide = !secondControlWithAttribute;

    if (noLayoutAttributeOnRightSide) {
        // floating number

        constant = [self parseFloatingPointNumberReportError:YES];
        if (constant == CGFLOAT_MIN) {
            return nil;
        }

    } else {

        multiplier = [self parseMultiplierExpressionReportError:NO];
        if (multiplier == CGFLOAT_MIN) {
            multiplier = 1.0f;
        }

        [self omitWhiteSpaces];

        constant = [self parseConstantExpressionReportError:NO];
        if (constant == CGFLOAT_MIN) {
            constant = 0.0f;
        }

    }

    [self omitWhiteSpaces];

    // Ensure that it's end of string already
    atom = [_lexer next];
    if (atom.atomType != PLAtomTypeEndOfInput) {
        [self logErrorExpectedAtomType:PLAtomTypeEndOfInput gotAtom:atom];
        return nil;
    }

    return [self buildConstraintWithFirstControlAttributeSegments:firstControlWithAttribute
                                                         relation:relation
                               secondControlWithAttributeSegments:secondControlWithAttribute
                                                       multiplier:multiplier
                                                         constant:constant views:views];

}

#pragma mark - parsing helpers

// controlName.attrName
- (NSArray *)parseControlAttributeReportErrorOnFailure:(BOOL)reportError {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    NSString *controlName = nil;
    NSString *controlAttribute = nil;

    NSUInteger initialLexerState = _lexer.currentState;

    // control name
    atom = [_lexer next];
    if (atom.atomType == PLAtomTypeIdentifier) {
        controlName = atom.stringData;
    } else {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedAtomType:PLAtomTypeIdentifier gotAtom:atom];
        return nil;
    }

    // dot
    atom = [_lexer next];
    if (atom.atomType != PLAtomTypeDot) {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedAtomType:PLAtomTypeDot gotAtom:atom];
        return nil;
    }

    // control attribute
    atom = [_lexer next];
    if (atom.atomType == PLAtomTypeIdentifier) {
        controlAttribute = atom.stringData;
    } else {
        [_lexer setCurrentState:initialLexerState];
        [self logErrorExpectedAtomType:PLAtomTypeIdentifier gotAtom:atom];
        return nil;
    }

    return @[controlName, controlAttribute];

}

// '*' <float number>
- (CGFloat)parseMultiplierExpressionReportError:(BOOL)reportError {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    NSUInteger initialLexerState = _lexer.currentState;

    atom = [_lexer next];
    if (atom.atomType != PLAtomTypeAsterisk) {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedAtomType:PLAtomTypeIdentifier gotAtom:atom];
        return CGFLOAT_MIN;
    }

    [self omitWhiteSpaces];

    CGFloat multiplier = [self parseFloatingPointNumberReportError:YES];
    if (multiplier == CGFLOAT_MIN) {
        [_lexer setCurrentState:initialLexerState];
        return CGFLOAT_MIN;
    }

    return multiplier;

}

// ['+' | '-'] <float number>
- (CGFloat)parseConstantExpressionReportError:(BOOL)reportError {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    NSUInteger initialLexerState = _lexer.currentState;

    atom = [_lexer next];
    if (atom.atomType != PLAtomTypePlus && atom.atomType != PLAtomTypeMinus) {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedSignAtomTypeAndGotAtom:atom];
        return CGFLOAT_MIN;
    }

    CGFloat sign = (atom.atomType == PLAtomTypePlus) ? 1.0f : -1.0f;

    [self omitWhiteSpaces];

    CGFloat constant = [self parseFloatingPointNumberReportError:YES];
    if (constant == CGFLOAT_MIN) {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedFloatNumberAndGotAtom:atom];
        return CGFLOAT_MIN;
    }

    return constant * sign;

}

- (CGFloat)parseFloatingPointNumberReportError:(BOOL)reportError {

    PLAttributeConstraintVisualFormatAtom *atom = nil;

    NSUInteger initialLexerState = _lexer.currentState;

    atom = [_lexer next];
    if (atom.atomType != PLAtomTypeFloatingPointNumber) {
        [_lexer setCurrentState:initialLexerState];
        if (reportError) [self logErrorExpectedAtomType:PLAtomTypeFloatingPointNumber gotAtom:atom];
        return CGFLOAT_MIN;
    }

    return [atom.stringData floatValue];

}

#pragma mark -

- (NSLayoutRelation)relationFromAtom:(PLAttributeConstraintVisualFormatAtom *)atom {

    NSAssert(atom.atomType == PLAtomTypeRelationEqual || atom.atomType == PLAtomTypeRelationLessOrEqual || atom.atomType == PLAtomTypeRelationGreaterOrEqual,
    @"Relation atom expected. Received: %@", atom);

    unichar firstCharOfRelation = [atom.stringData characterAtIndex:0];
    switch (firstCharOfRelation) {
        case '=':
            return NSLayoutRelationEqual;
        case '<':
            return NSLayoutRelationLessThanOrEqual;
        case '>':
            return NSLayoutRelationGreaterThanOrEqual;
        default:
            @throw [NSException exceptionWithName:@"Invalid state" reason:nil userInfo:nil];

    }

}

#pragma mark - error handling

- (void)logErrorExpectedAtomType:(PLAtomType)expectedAtomType gotAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    [self beginErrorLogging];
#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Expected: %@ got: %@", @(expectedAtomType), atom);
#endif
    [self printText:_lexer.text pointingAtCharAtIndex:atom.startIndex];
    [self endErrorLogging];
}

- (void)logErrorExpectedSignAtomTypeAndGotAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    [self beginErrorLogging];
#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Expected sign (+-). Got: %@", atom);
#endif
    [self printText:_lexer.text pointingAtCharAtIndex:atom.startIndex];
    [self endErrorLogging];
}

- (void)logErrorExpectedFloatNumberAndGotAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    [self beginErrorLogging];
#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Expected number. Got: %@", atom);
#endif
    [self printText:_lexer.text pointingAtCharAtIndex:atom.startIndex];
    [self endErrorLogging];
}

- (void)logErrorExpectedRelationAtomAndGotAtom:(PLAttributeConstraintVisualFormatAtom *)atom {
    [self beginErrorLogging];
#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Expected relation (<= | == | >=). Got: %@", atom);
#endif
    [self printText:_lexer.text pointingAtCharAtIndex:atom.startIndex];
    [self endErrorLogging];
}

- (void)endErrorLogging {
    NSLog(@"======================================================================");
}

- (void)beginErrorLogging {
    NSLog(@"======================================================================");
    NSLog(@"PLAttributeConstraintVisualFormatParser: Could not parse constraint format.");
}

- (void)printText:(NSString *)text pointingAtCharAtIndex:(NSUInteger)index {
    NSLog(@"%@", text);
    NSMutableString *arrow = [NSMutableString string];
    for (NSUInteger i = 1; i < index; i++) {
        [arrow appendString:(i % 2 == 0) ? @" " : @"-"];
    }
    [arrow appendString:@"^"];
    NSLog(@"%@", arrow);
}

#pragma mark -

- (void)omitWhiteSpaces {
    [_lexer omitWhiteSpaces];
}

#pragma mark - constraint building


- (NSLayoutConstraint *)buildConstraintWithFirstControlAttributeSegments:(NSArray *)firstControlAttributeSegments
                                                                relation:(NSLayoutRelation)relation
                                      secondControlWithAttributeSegments:(NSArray *)secondControlAttributeSegments
                                                              multiplier:(CGFloat)multiplier
                                                                constant:(CGFloat)constant
                                                                   views:(NSDictionary *)views {

    UIView *firstControl = [views objectForKey:firstControlAttributeSegments[0]];
    NSLayoutAttribute firstControlAttr = [PLConstraintLayoutAttributeMapper attributeFromString:firstControlAttributeSegments[1]];

    if (firstControl == nil) {
        NSLog(@"PLAttributeConstraintVisualFormatParser: invalid first control. %@ unknown.", firstControl);
        return nil;
    }

    if (firstControlAttr == NSLayoutAttributeNotAnAttribute) {
        NSLog(@"PLAttributeConstraintVisualFormatParser: invalid first control attribute. %@ unknown.", firstControlAttributeSegments[1]);
        return nil;
    }

    UIView *secondControl = nil;
    NSLayoutAttribute secondControlAttr = NSLayoutAttributeNotAnAttribute;

    if (secondControlAttributeSegments) {

        secondControl = [views objectForKey:secondControlAttributeSegments[0]];
        secondControlAttr = [PLConstraintLayoutAttributeMapper attributeFromString:secondControlAttributeSegments[1]];

        if (firstControl == nil) {
            NSLog(@"PLAttributeConstraintVisualFormatParser: invalid second control. %@ unknown.", secondControlAttributeSegments[0]);
            return nil;
        }

        if (firstControlAttr == NSLayoutAttributeNotAnAttribute) {
            NSLog(@"PLAttributeConstraintVisualFormatParser: invalid second control attribute. %@ unknown.", secondControlAttributeSegments[1]);
            return nil;
        }

    }
    else {
        if (firstControlAttr != NSLayoutAttributeWidth && firstControlAttr != NSLayoutAttributeHeight) {

            // HACK:
            //
            // you can create constraint like that: view.width <= 100
            // however, view.top <= 100 is not supported in the same way
            //
            // in first case, you'll pass
            //      nil     NSLayoutAttributeNotAnAttribute
            // as second control and attribute related to that constraint
            //
            // in second case, that approach will result in a crash
            // so basically I create constraint:    view.width <= view.width * 0 + 100
            //
            //   And that works   ;)
            //

            secondControl = firstControl;
            secondControlAttr = firstControlAttr;
            multiplier = 0;

        }
    }

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstControl
                                                                  attribute:firstControlAttr
                                                                  relatedBy:relation
                                                                     toItem:secondControl
                                                                  attribute:secondControlAttr
                                                                 multiplier:multiplier
                                                                   constant:constant];

#if PLAttributeConstraintFormatParserDebuggingLogsEnabled
    NSLog(@"PLAttributeConstraintVisualFormatParser: Constraint was built: %@", constraint);
#endif

    return constraint;

}

@end
