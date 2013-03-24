//
//  CTRTimerModel.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerModel.h"

@implementation CTRTimerModel

-(id)initWithCoffeeName:(NSString *)coffeeName duration:(NSInteger)duration
{
    self = [super init];
    if (self == nil) return nil;
    
    self.coffeeName = coffeeName;
    self.duration = duration;
    
    return self;
}

@end
