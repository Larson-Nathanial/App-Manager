//
//  StepSix.m
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "StepSix.h"
#import "StepSeven.h"
#import "Connection.h"

@interface StepSix()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation StepSix

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Step 6 of 7";
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

- (IBAction)nextButtonAction:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] didUpdateBankCountry:self.chooseCountry.titleLabel.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }completion:^(BOOL finished){
                [self.navigationController pushViewController:[StepSeven new] animated:YES];
            }];
        });
        
    });
    
}

- (IBAction)chooseCountryAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Country" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"United States" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.chooseCountry setTitle:@"United States" forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Canada" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.chooseCountry setTitle:@"Canada" forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
