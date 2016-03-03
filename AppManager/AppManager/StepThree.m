//
//  StepThree.m
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "StepThree.h"
#import "StepFour.h"
#import "Connection.h"

@interface StepThree ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation StepThree

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Step 3 of 7";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.nextOutlet.layer.cornerRadius = 3.0;
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


- (IBAction)nextButtonAction:(id)sender {
    
    if (self.phoneNumberField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Phone is required." message:@"Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            [[Connection connection] didUpdatePhoneNumber:self.phoneNumberField.text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 0.0;
                }completion:^(BOOL finished){
                    [self.navigationController pushViewController:[StepFour new] animated:YES];
                }];
            });
            
        });
    }

    
}

@end
