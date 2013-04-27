//
//  CTRTimerModel.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerModel.h"

@implementation CTRTimerModel

-(id)initWithName:(NSString *)name duration:(NSInteger)duration type:(CTRTimerModelType)type
{
    self = [super init];
    if (self == nil) return nil;
    
    self.name = name;
    self.duration = duration;
    self.type = type;
    
    return self;
}

@end
