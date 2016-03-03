//
//  LoginCreateAccount.m
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "LoginCreateAccount.h"
#import "StepOne.h"
#import "Connection.h"

@interface LoginCreateAccount ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation LoginCreateAccount

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Getting Started";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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

- (void)viewWillAppear:(BOOL)animated
{
    self.nextOutlet.layer.cornerRadius = 3.0;
}

- (IBAction)nextButtonAction:(id)sender {
    
    // Login
    // Email matches, but password doesn't - display alert
    // Email doesn't match, create account and move to next step. Step 1 of 7
    
    if (self.emailField.text.length == 0 || self.passwordField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"All fields required." message:@"Please provide your email address and a password." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            NSString *response = [[Connection connection] loginWithEmail:self.emailField.text andPassword:self.passwordField.text];
            
            if (response == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        _coverView.alpha = 0.0;
                    }completion:^(BOOL finished){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connection Failed." message:@"Please make sure you have a good internet connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                });
            }else if ([response isEqualToString:@"Valid"]) { // Login
                if ([[Connection connection] didSetAccountIdForEmail:self.emailField.text]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.3 animations:^{
                            _coverView.alpha = 0.0;
                        }completion:^(BOOL finished){
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }];
                    });
                }
            }else if ([response isEqualToString:@"Invalid"]) { // Show Error
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        _coverView.alpha = 0.0;
                    }completion:^(BOOL finished){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Password." message:@"Your password didn't match.  Please try again." preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                        }]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                });
            }else { // Create Account
                if ([[Connection connection] didCreateAccountForEmail:self.emailField.text andPassword:self.passwordField.text]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:0.3 animations:^{
                            _coverView.alpha = 0.0;
                        }completion:^(BOOL finished){
                            [self.navigationController pushViewController:[StepOne new] animated:YES];
                        }];
                    });
                }
            }
        });
        
    }
}

@end
