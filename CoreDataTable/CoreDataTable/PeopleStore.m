//
//  PeopleStore.m
//  CoreList
//
//  Created by Bradley Robert Schmidt on 3/17/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import "PeopleStore.h"
#import "People.h"

@interface PeopleStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation PeopleStore

@synthesize allItems;

+ (id)sharedStore
{
    static PeopleStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[PeopleStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error= nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
        
        [self loadAllPeople];
        }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (People *)createItem
{
    People *person = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:context];
    person.isSelected = [NSNumber numberWithInt:1];
    [self.privateItems addObject:person];
    
    return person;
}

- (void)removeItem:(People *)item
{
    [context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingString:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (void)loadAllPeople
{
    if (!_privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"People"];
        [request setEntity:e];
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}


@end
