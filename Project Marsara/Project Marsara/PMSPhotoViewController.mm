//
//  PMPhotoViewController.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSPhotoViewController.h"
#import "PMSImageProcessing.h"

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
    self.imageView.image = chosenImage;
    
    // OpenCV calculations for dominant color in image
    cv::Mat src = [PMSImageProcessing cvMatFromUIImage:chosenImage];
    cv::Vec3d result = [PMSImageProcessing findDominantColor:src];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showColour"]){
        PMSResultViewController *controller = (PMSResultViewController*)segue.destinationViewController;
        // TODO: need method to convert color to string
        controller.resultingColour = @"Blue";
    }
}


@end
