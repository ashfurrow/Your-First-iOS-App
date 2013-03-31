//
//  CTRTimerModel.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-21.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTRTimerModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger duration;

-(id)initWithName:(NSString *)name
         duration:(NSInteger)duration;

@end
