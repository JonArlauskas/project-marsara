//
//  PMPhotoViewController.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSResultViewController.h"

@interface PMSPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePicture:(UIButton *)sender;
- (IBAction)selectPicture:(UIButton *)sender;



@end
