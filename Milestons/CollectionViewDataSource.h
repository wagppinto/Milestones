//
//  CollectionViewDataSource.h
//  Milestons
//
//  Created by Dalton on 5/30/15.
//  Copyright (c) 2015 Dalton. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#import "EntryController.h"

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) Entry *entry;


@end
