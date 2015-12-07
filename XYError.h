//
//  XYError.h
//  XY
//
//  Created by Julian on 13-3-10.
//  Copyright (c) 2013年 Julian. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface XYError : NSObject
+(NSDictionary *) errorUserInfoWithDescription:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion ;
@end
