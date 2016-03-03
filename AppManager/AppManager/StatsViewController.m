//
//  StatsViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "StatsViewController.h"
#import "Connection.h"

@interface StatsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *sections;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@property (nonatomic) NSString *countOfDownloads;
@property (nonatomic) NSString *countOfActiveUsers;

@end

@implementation StatsViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Stats";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.sections = @[@"Cart Recovery", @"Popular Products", @"Customers"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.view addSubview:_tableView];
    [self getCustomerStats];
}

- (void)getCustomerStats
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
        self.countOfDownloads = [[Connection connection] getCountOfDownloadsForAccountId];
        self.countOfActiveUsers = [[Connection connection] getCountOfActiveUsersForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aView = [UIView new];
    aView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 60.0);
    aView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(10.0, 0.0, self.view.bounds.size.width - 20.0, 60.0);
//    label.text = [self.sections objectAtIndex:section];
    label.text = @"Customers";
    label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    
    [aView addSubview:label];
    
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.sections.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 2;
//    }else {
//        return 3;
//    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
//    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [[cell viewWithTag:654] removeFromSuperview];
    
//    if (indexPath.section == 0 || indexPath.section == 1) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        button.frame = CGRectMake(0.0, 0.0, 100.0, 30.0);
//        button.tag = 654;
//        
//        if (indexPath.section == 0) {
//            [button setTitle:@"Recover" forState:UIControlStateNormal];
//        }else {
//            [button setTitle:@"Promote" forState:UIControlStateNormal];
//        }
//        
//        [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16.0]];
//        
//        button.layer.borderColor = button.tintColor.CGColor;
//        button.layer.borderWidth = 1.0;
//        button.layer.cornerRadius = 3.0;
//        
//        cell.accessoryView = button;
//    }else {
        if (indexPath.row == 0) {
            if (self.countOfDownloads == nil) {
                cell.textLabel.text = @"Downloads: Unavailable";
            }else {
                cell.textLabel.text = [NSString stringWithFormat:@"Downloads: %@", self.countOfDownloads];
            }
        }else {
            if (self.countOfActiveUsers == nil) {
                cell.textLabel.text = @"Active: Unavailable";
            }else {
                cell.textLabel.text = [NSString stringWithFormat:@"Active: %@", self.countOfActiveUsers];
            }
        }
//    }
    
    [[cell viewWithTag:254] removeFromSuperview];
    if (indexPath.row >= 0) {
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
        aView.tag = 254;
        [cell addSubview:aView];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
