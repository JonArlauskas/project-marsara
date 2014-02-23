//
//  PMSCellViewController.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/23/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSCellViewController.h"
#import "PMSResultViewController.h"

@interface PMSCellViewController ()

@end

@implementation PMSCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.itemImageView.image = [UIImage imageWithData:[self.item valueForKey:@"image"]];
    NSString *descriptionText = [NSString stringWithFormat:
                                 @"%@ %@",
                                 [self.item valueForKey:@"color"], [self.item valueForKey:@"type"]];
    self.itemDescriptionLabel.text = descriptionText;
    // Initialize array for item types
    self.itemTypeArray  = [[NSArray alloc] initWithObjects:@"Overwear",@"Shirt",@"Bottom",@"Shoes",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View Data Source methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return 4;
}

#pragma mark - Picker View delegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.itemTypeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - Function for handling segue actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PMSResultViewController *controller = (PMSResultViewController *)segue.destinationViewController;
    // Get info from Core Data object
    controller.resultingColour = [self.item valueForKey:@"color"];
    controller.fromItemType = [self.item valueForKey:@"type"];
    controller.fromImage = [UIImage imageWithData:[self.item valueForKey:@"image"]];
    // Get current value of picker
    NSInteger row = [self.itemTypePicker selectedRowInComponent:0];
    controller.toItemType = [self.itemTypeArray objectAtIndex:row];
    // Because we are coming from Library disable save button in result view
    controller.displaySaveButton = NO;
}

@end
