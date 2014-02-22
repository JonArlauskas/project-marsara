//
//  PMPhotoViewController.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSPhotoViewController.h"
#import "PMSOpenCVFunctions.h"
using namespace cv;

@interface PMSPhotoViewController ()

@end

@implementation PMSPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Handle case where device has no camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!"
                                                     message:@"Welcome to OpenCV"
                                                    delegate:self
                                           cancelButtonTitle:@"Continue"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

# pragma mark - UIButton action handler methods

- (IBAction)takePicture:(UIButton *)sender {
    // Create image picker and set source to be camera
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPicture:(UIButton *)sender {
    // Create image picker and set source to be photo library
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    Mat src = [PMSOpenCVFunctions cvMatFromUIImage:chosenImage];
    Mat HSV;
    Mat threshold;
    cvtColor(src,HSV,CV_BGR2HSV);
    inRange(HSV,Scalar(106,60,90),Scalar(124,255,255),threshold);
    UIImage *filteredImage = [PMSOpenCVFunctions UIImageFromCVMat:HSV];
    
    self.imageView.image = filteredImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
