//
//  EntryController.m
//  Milestons
//
//  Created by Dalton on 5/2/15.
//  Copyright (c) 2015 Dalton. All rights reserved.
//

#import "EntryController.h"
#import "Entry.h"
#import "Scrapbook.h"


@implementation EntryController

+ (EntryController *) sharedInstance {
    static EntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [EntryController new];
        [sharedInstance loadEntriesFromParse];
    });
    return sharedInstance;
}


#pragma mark - Create

- (void)createEntryWithTitle: (NSString *) title description: (NSString *)description date:(NSDate *)timestamp {
    
    Entry *entry = [Entry object];
    
    entry.titleOfEntry = title;
    entry.descriptionOfEntry = description;
    entry.timestamp = timestamp;
    
    [entry pinInBackgroundWithBlock:nil];
    [entry saveInBackground];
    
}


#pragma mark - Read

- (void)loadEntriesFromParse {
    
    PFQuery *query = [Entry query];
    
    // Without notifications to update the tableview we'll need to restart the app to get the tableview to load
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (Entry *entry in objects) {
            
            [entry pinInBackgroundWithBlock:nil];
        }
    }];
}


- (void)loadTheseEntriesFromParse {
    
    
    PFQuery *entryQuery = [Entry query];
    
    Entry *myEntry = [Entry new];
    
    Scrapbook *myScrapbook = [Scrapbook new];
    
    myEntry.scrapbook = myScrapbook;
    
    [entryQuery whereKey:@"scrapbook" equalTo:myScrapbook];
    
    [myEntry pinInBackgroundWithBlock:nil];
    
}


- (NSArray *)entries {
    
    PFQuery *query = [Entry query];
    [query fromLocalDatastore];
    return [query findObjects];
}


#pragma mark - Update

- (void)updateEntry:(Entry *)entry {
    
    [entry pinInBackgroundWithBlock:nil];
    [entry saveInBackground];
    
}

#pragma mark - Delete

- (void)removeEntry:(Entry *)entry {
    
    [entry unpinInBackgroundWithBlock:nil];
    [entry deleteInBackgroundWithBlock:nil];
}


@end
