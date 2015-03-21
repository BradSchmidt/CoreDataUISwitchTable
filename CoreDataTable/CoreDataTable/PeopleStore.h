//
//  PeopleStore.h
//  CoreList
//
//  Created by Bradley Robert Schmidt on 3/17/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class People;

@interface PeopleStore : NSObject
{
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (People *)createItem;
- (void)removeItem:(People *)item;

- (NSString *)itemArchivePath;

- (BOOL)saveChanges;

- (void)loadAllPeople;

@end
