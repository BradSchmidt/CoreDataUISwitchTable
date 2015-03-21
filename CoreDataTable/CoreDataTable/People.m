//
//  People.m
//  CoreList
//
//  Created by Bradley Robert Schmidt on 3/17/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import "People.h"

@implementation People

@synthesize isSelected;

- (id)initWithFirstName:(NSString *)first
               LastName:(NSString *)last
{
    // Call the superclass's designated initializer
    self = [super init];
    if (self) {
        self.firstName = first;
        self.lastName = last;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (id)init
{
    return [self initWithFirstName:nil LastName:nil];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ %@", self.firstName, self.lastName];
    return descriptionString;
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    [aCoder encodeBool:isSelected forKey:@"isSelected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setFirstName:[aDecoder decodeObjectForKey:@"firstName"]];
        [self setLastName:[aDecoder decodeObjectForKey:@"lastName"]];
        [self setIsSelected:[aDecoder decodeBoolForKey:@"isSelected"]];
    }
    return self;
}

@end
