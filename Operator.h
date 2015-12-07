//
//  Operator.h
//  XY
//
//  Created by Julian on 13-2-13.
//  Copyright (c) 2013年 Julian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Operator:NSObject// : NSManagedObject

@property (nonatomic, assign) NSNumber * leftAssoc;
@property (nonatomic, assign) NSString * name;
@property (nonatomic, assign) NSNumber * precedence;
@property (nonatomic, assign) NSNumber * operandSeveral;

@end
