//
//  PMPhotoViewController.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSResultViewController.h"

@interface PMSPhotoViewController : UIViewController <UIImagePickerControllerDelegate,
                                                      UINavigationControllerDelegate,
                                                      UIPickerViewDataSource,
                                                      UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *itemTypePicker;
@property (strong, nonatomic) NSArray *itemTypeArray;
@property (weak, nonatomic) IBOutlet UIButton *getRecommendations;
@property (strong, nonatomic) NSString *fromItemType;
@property (strong, nonatomic) NSString *toItemType;
@property (strong, nonatomic) NSString *inputColor;
@property (nonatomic) UIImage *fromImage;
- (IBAction)takePicture:(UIButton *)sender;
- (IBAction)selectPicture:(UIButton *)sender;
- (IBAction)getRecommendations:(UIButton *)sender;
- (void)backgroundDone;
@property (weak, nonatomic) IBOutlet UILabel *TestLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *recommendActivityIndicator;



@end
