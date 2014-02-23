//
//  PMSCellViewController.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/23/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMSCellViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (nonatomic) NSManagedObject *item;
@property (strong, nonatomic) NSArray *itemTypeArray;
@property (weak, nonatomic) IBOutlet UIPickerView *itemTypePicker;

@end
