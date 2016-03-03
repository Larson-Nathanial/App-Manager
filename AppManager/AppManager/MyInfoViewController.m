//
//  MyInfoViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "MyInfoViewController.h"
#import "Connection.h"

@interface MyInfoViewController ()<UITextFieldDelegate>

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation MyInfoViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"My Info";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.businessName.delegate = self;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.phoneNumber.delegate = self;
    self.emailAddress.delegate = self;
    
    [self loadAccountInformation];
}

- (void)viewDidAppear:(BOOL)animated
{
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.tintColor = [UIColor colorWithRed:244.0 / 255.0 green:88.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
}

- (void)loadAccountInformation
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        NSArray *array = [[Connection connection] loadAccountInformationForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.businessName.text = [[array objectAtIndex:0] valueForKey:@"business_name"];
            self.firstName.text = [[array objectAtIndex:0] valueForKey:@"first_name"];
            self.lastName.text = [[array objectAtIndex:0] valueForKey:@"last_name"];
            self.phoneNumber.text = [[array objectAtIndex:0] valueForKey:@"phone"];
            self.emailAddress.text = [[array objectAtIndex:0] valueForKey:@"email"];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (void)saveButtonAction
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didUpdateAccountIdWithBusinessName:self.businessName.text firstName:self.firstName.text lastName:self.lastName.text phoneNumber:self.phoneNumber.text email:self.emailAddress.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }completion:^(BOOL finished){
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
        
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
