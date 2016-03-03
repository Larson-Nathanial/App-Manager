//
//  MyAccountViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyInfoViewController.h"
#import "PlanInfoViewController.h"
#import "BankInfoViewController.h"
#import "PoliciesViewController.h"

@interface MyAccountViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *options;

@end

@implementation MyAccountViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Account";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.options = @[@"My Info", @"Plan Info", @"Bank Info", @"Policies"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [[cell viewWithTag:254] removeFromSuperview];
    if (indexPath.row > 0) {
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
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MyInfoViewController new] animated:YES];
    }else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[PlanInfoViewController new] animated:YES];
    }else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[BankInfoViewController new] animated:YES];
    }else {
        [self.navigationController pushViewController:[PoliciesViewController new] animated:YES];
    }
}


@end
