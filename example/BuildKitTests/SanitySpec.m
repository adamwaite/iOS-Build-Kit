//
//  SanitySpec.m
//  BuildKit
//
//  Created by Adam Waite on 07/02/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(SanitySpec)

describe(@"Sanity", ^{
    
    specify(^{
        [[theValue(YES) should] equal:theValue(YES)];
    });
    
});

SPEC_END