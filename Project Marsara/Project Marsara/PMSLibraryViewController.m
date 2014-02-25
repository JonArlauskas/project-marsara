//
//  PMSLibraryViewController.m
//  Project Marsara
//
//  Created by Nicolas Langley on 2/23/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import "PMSLibraryViewController.h"
#import "PMSLibraryCell.h"
#import "PMSCellViewController.h"

@interface PMSLibraryViewController ()

@end

@implementation PMSLibraryViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PMSLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LibCell" forIndexPath:indexPath];
    UIImage *itemImage = [UIImage imageWithData:[[self.items objectAtIndex:indexPath.row] valueForKey:@"image"]];
    cell.cellImageView.image = itemImage;
    return cell;
}

#pragma mark - Core Data functions

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fetch the items from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
    self.items = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.collectionView reloadData];
}

#pragma mark - Prepare for Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    PMSCellViewController *cellViewController = (PMSCellViewController *)segue.destinationViewController;
    cellViewController.item = [self.items objectAtIndex:indexPath.row];
}

@end
