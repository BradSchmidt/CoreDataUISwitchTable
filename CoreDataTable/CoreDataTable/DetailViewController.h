//
//  DetailViewController.h
//  CoreList
//
//  Created by Bradley Robert Schmidt on 3/17/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class People;

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;

@property (nonatomic, strong) People *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
