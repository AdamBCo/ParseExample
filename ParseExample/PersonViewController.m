//
//  ViewController.m
//  ParseExample
//
//  Created by Adam Cooper on 10/27/14.
//  Copyright (c) 2014 Pixifly. All rights reserved.
//

#import "PersonViewController.h"
#import <Parse/Parse.h>

@interface PersonViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSArray *peopleArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *ageTextfield;
@property (weak, nonatomic) IBOutlet UITextField *occupationTextField;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshDisplay];
}

- (IBAction)onAddPersonButtonPressed:(id)sender {
    PFObject *person = [PFObject objectWithClassName:@"Person"];
    
    person[@"name"] = self.nameTextfield.text;
    person[@"age"] = self.ageTextfield.text;
    person[@"occupation"] = self.occupationTextField.text;
    
    [person saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",[error userInfo]);
        } else{
            [self refreshDisplay];
            self.nameTextfield.text = @"";
            self.ageTextfield.text = @"";
            self.occupationTextField.text = @"";
        }
    }];
}

-(void)refreshDisplay{
    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@",error.userInfo);
            self.peopleArray = [NSArray new];
        } else{
            self.peopleArray = objects;
            [self.tableview reloadData];
        }
    }];
}




#pragma TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peopleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    cell.textLabel.text = [self.peopleArray objectAtIndex:indexPath.row] [@"name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *person = [self.peopleArray objectAtIndex:indexPath.row];
        [person deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@",[error userInfo]);
            } else{
                [self refreshDisplay];
            }
        }];
    }
}


@end
