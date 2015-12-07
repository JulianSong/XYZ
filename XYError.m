//
//  XYError.m
//  XY
//
//  Created by Julian on 13-3-10.
//  Copyright (c) 2013年 Julian. All rights reserved.
//

#import "XYError.h"

@implementation XYError
+(NSDictionary *) errorUserInfoWithDescription:(NSString *)description recoverySuggestion:(NSString *)recoverySuggestion {
    
    NSArray *keys = [NSArray arrayWithObjects: NSLocalizedDescriptionKey, NSLocalizedRecoverySuggestionErrorKey, nil];
    NSArray *values = [NSArray arrayWithObjects:description, recoverySuggestion, nil];
    NSDictionary *userDict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    return userDict;
}
@end
