//
//  Expression.h
//  XY
//
//  Created by Julian on 13-2-25.
//  Copyright (c) 2013年 Julian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expression : NSManagedObject

@property (nonatomic, retain) NSString * expressionString;
@property (nonatomic, retain) NSNumber * isHide;
@property (nonatomic, retain) id notation;
@property (nonatomic, retain) id prefixNotation;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) id color;

@end
