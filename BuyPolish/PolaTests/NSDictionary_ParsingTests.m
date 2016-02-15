#import <XCTest/XCTest.h>
#import "NSDictionary+Parsing.h"

@interface NSDictionary_ParsingTests : XCTestCase
@property (nonatomic, strong) NSDictionary *sut;
@end

@implementation NSDictionary_ParsingTests

- (void)setUp {
    [super setUp];
    self.sut = [NSDictionary new];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - nilOrStringForKey:

- (void)testThatReturnedStringWillBeNilIfThereWillBeNoObject {
    XCTAssertNil([self.sut nilOrStringForKey:@"key"]);
}

- (void)testThatReturnedStringWillBeCorrectIfItsString {
    self.sut = @{@"key": @"test"};
    XCTAssertEqual([self.sut nilOrStringForKey:@"key"], @"test");
}

- (void)testThatReturnedStringWillBeNilIfItsNotString {
    self.sut = @{@"key": @5};
    XCTAssertNil([self.sut nilOrStringForKey:@"key"]);
}

#pragma mark - nilOrNumberForKey:

- (void)testThatReturnedNumberWillBeNilIfThereWillBeNoObject {
    XCTAssertNil([self.sut objectForKey:@"key"]);
}

- (void)testThatReturnedNumberWillBeCorrectIfItsString {
    self.sut = @{@"key": @5};
    XCTAssertEqual([self.sut nilOrNumberForKey:@"key"], @5);
}

- (void)testThatReturnedNumberWillBeNilIfItsNotString {
    self.sut = @{@"key": @"string"};
    XCTAssertNil([self.sut nilOrNumberForKey:@"key"]);
}

@end
