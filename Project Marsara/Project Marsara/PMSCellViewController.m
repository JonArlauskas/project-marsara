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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Function for handling segue actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showColour"]){
        PMSResultViewController *controller = (PMSResultViewController *)segue.destinationViewController;
        controller.resultingColour = [self.item valueForKey:@"color"];
        controller.fromItemType = [self.item valueForKey:@"type"];
        //controller.toItemType = self.toItemType;
        controller.fromImage = [UIImage imageWithData:[self.item valueForKey:@"image"]];
    }
}

@end
