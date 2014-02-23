//
//  PMSLibraryViewController.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/23/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMSLibraryViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong) NSMutableArray *items;

@end
