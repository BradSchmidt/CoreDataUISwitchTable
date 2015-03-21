//
//  People.h
//  CoreDataTable
//
//  Created by Bradley Robert Schmidt on 3/19/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface People : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic) NSNumber * isSelected;

@end
