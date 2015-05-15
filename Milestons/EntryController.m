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

@interface EntryController()

@property (nonatomic, strong) NSArray *entries;

@end

@implementation EntryController

+ (EntryController *) sharedInstance {
    static EntryController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [EntryController new];
        [sharedInstance loadTheseEntriesFromParse:^(NSError *error) {
            // Nothing
        }];
    });
    return sharedInstance;
}


#pragma mark - Create

- (void)createEntryWithTitle: (NSString *) title description: (NSString *)description date:(NSDate *)timestamp inScrapbook: (Scrapbook *)scrapbook {
    
    Entry *entry = [Entry object];
    
    entry.titleOfEntry = title;
    entry.descriptionOfEntry = description;
    entry.scrapbook = scrapbook;
    entry.timestamp = timestamp;
    
    [entry pinInBackground];
    [entry saveInBackground];
    
    NSMutableArray *mutableEntries = [NSMutableArray arrayWithArray:self.entries];
    [mutableEntries insertObject:scrapbook atIndex:0];
    self.entries = mutableEntries;
}



#pragma mark - Read


- (void)loadTheseEntriesFromParse:(void (^)(NSError *error))completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Scrapbook"];
    [query fromLocalDatastore];
    [query includeKey:@"photos"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            self.entries = objects;
            completion(nil);
        } else {
            completion(error);
        }
    }];
    
}
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Scrapbook"];
//        
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (!error) {
//        
//        self.entries = objects;
//            NSLog(@"%lu", (unsigned long)self.entries.count);
//            
//        } else {
//            
//            NSLog(@"Error");
//        }
//        
//    }];
//}




- (NSArray *)entries {
    
    PFQuery *query = [Entry query];
    [query fromLocalDatastore];
    return [query findObjects];
}


#pragma mark - Update

- (void)updateEntry:(Entry *)entry {
    
    [entry pinInBackground];
    [entry saveInBackground];
    
}

#pragma mark - Delete

- (void)removeEntry:(Entry *)entry {
    
    NSMutableArray *mutableEntries = [NSMutableArray arrayWithArray:self.entries];
    [mutableEntries removeObject:entry];
    self.entries = mutableEntries;
    
    [entry unpinInBackground];
    [entry deleteInBackground];
}


@end
