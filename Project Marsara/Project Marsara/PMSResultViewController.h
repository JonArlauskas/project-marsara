//
//  PMResultViewController.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSOutfitRecommender.h"

@interface PMSResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *colorResult;
@property (nonatomic) NSString *resultingColour;
@property (nonatomic) NSString *fromItemType;
@property (nonatomic) NSString *toItemType;
@property (nonatomic) UIImage *fromImage;
@property (weak, nonatomic) IBOutlet UILabel *recommendOutput;
- (IBAction)saveButton:(UIBarButtonItem *)sender;

@end
