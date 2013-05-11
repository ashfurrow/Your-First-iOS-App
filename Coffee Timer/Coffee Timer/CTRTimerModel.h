//
//  CTRTimerModel.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-05-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum : int32_t {
    CTRTimerModelTypeCoffee = 0,
    CTRTimerModelTypeTea
}CTRTimerModelType;

@interface CTRTimerModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t duration;
@property (nonatomic) int32_t type;
@property (nonatomic) int32_t displayOrder;

@end
