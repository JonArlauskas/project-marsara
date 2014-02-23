//
//  PMResultViewController.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSResultViewController.h"

@interface PMSResultViewController ()

@end

@implementation PMSResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *text = [NSString stringWithFormat:
                      @"Matched %@ with %@ %@ ",
                      self.toItemType, self.resultingColour, self.fromItemType];
    [self.colorResult setText:text];
    [self.colorResult setTextAlignment:NSTextAlignmentCenter];
    NSString *recommendText = [PMSOutfitRecommender generateOutfit:self.resultingColour toItemType:self.toItemType];
    [self.recommendOutput setText:recommendText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    [newItem setValue:self.resultingColour forKey:@"color"];
    [newItem setValue:self.fromItemType forKey:@"type"];
    
    [newItem setValue:UIImagePNGRepresentation(self.fromImage) forKey:@"image"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
