//
//  SanityTest.m
//  BuildKit
//
//  Created by Adam Waite on 06/02/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SanityTest : XCTestCase

@end

@implementation SanityTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSanity
{
    XCTAssertEqual(@"hey", @"hey", @"Insane!!!");
}

@end
