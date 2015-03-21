//
//  ListViewController.m
//  CoreList
//
//  Created by Bradley Robert Schmidt on 3/17/15.
//  Copyright (c) 2015 Bradley Robert Schmidt. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "People.h"
#import "PeopleStore.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"People";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        navItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)addNewItem:(id)sender
{
    People *person = [[PeopleStore sharedStore] createItem];
    
    DetailViewController *detail = [[DetailViewController alloc] initForNewItem:YES];
    detail.item = person;
    detail.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detail];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:NULL];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[PeopleStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray *items = [[PeopleStore sharedStore] allItems];
    People *item = items[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", item.firstName, item.lastName];
    
    UISwitch *switchController = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    if (item.isSelected == [NSNumber numberWithInt:1]) {
        [switchController setOn:YES animated:NO];
    }
    
    switchController.tag = indexPath.row;  //OK
    
    [switchController addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = switchController;
    return cell;
}


- (void)switchChanged:(id)sender
{
    UISwitch *switchCon = sender;
    
    NSArray *items = [[PeopleStore sharedStore] allItems];
    People *item = items[switchCon.tag];
    if (item.isSelected == [NSNumber numberWithInt:1]) {
        [item setIsSelected:[NSNumber numberWithInt:0]];
    } else {
        [item setIsSelected:[NSNumber numberWithInt:1]];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] initForNewItem:NO];
    NSArray *items = [[PeopleStore sharedStore] allItems];
    People *selectedItem = items[indexPath.row];
    detail.item = selectedItem;
    [[self navigationController] pushViewController:detail animated:YES];
}

- (void)   tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[PeopleStore sharedStore] allItems];
        People *item = items[indexPath.row];
        [[PeopleStore sharedStore] removeItem:item];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
