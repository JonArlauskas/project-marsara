//
//  PMSOutfitRecommender.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMSOutfitRecommender : NSObject

+ (NSString *)generateOutfit:(NSString *)color toItemType:(NSString *)toItemType;

@end
