//
//  PMSOutfitRecommender.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSOutfitRecommender.h"

@implementation PMSOutfitRecommender

+ (NSString *)generateOutfit:(NSString *)color toItemType:(NSString *)toItemType {
    NSDictionary* complementaryColors = @{@"Blue"   : @"Orange",
                                          @"Orange" : @"Blue",
                                          @"Purple" : @"Yellow",
                                          @"Yellow" : @"Purple",
                                          @"Red"    : @"Green",
                                          @"Green"  : @"Red",
                                          @"White"  : @"Any neutral color",
                                          @"Black"  : @"White"};
    NSString *matchingColor = [complementaryColors objectForKey:color];
    
    NSString *recommendation;
    if ([toItemType isEqualToString:@"Bottoms"]) {
        recommendation = @"Wear any color of bottoms you like";
    } else {
        recommendation = [NSString stringWithFormat:
                          @"You should wear %@ %@ ",
                          matchingColor, toItemType];
    }
    
    return recommendation;
    
}

@end
