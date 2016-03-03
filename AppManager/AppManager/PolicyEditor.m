//
//  PolicyEditor.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "PolicyEditor.h"
#import "Connection.h"

@interface PolicyEditor ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation PolicyEditor

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.policyType;
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    if ([self.policyType isEqualToString:@"Description"]) {
        self.textView.text = self.productObject.product_description;
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductChanges)];
        self.navigationItem.rightBarButtonItem = button;
    }else {
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePolicyChanges)];
        self.navigationItem.rightBarButtonItem = button;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
    
    [self loadAccountPolicies];
}

- (void)saveProductChanges
{
    if (self.textView.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Description!" message:@"Description required in order to save." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        self.productObject.product_description = self.textView.text;
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            [[Connection connection] didUpdateProductId:self.productObject.product_id withDescription:self.textView.text];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 0.0;
                }completion:^(BOOL finished){
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        });
    }
}

- (void)loadAccountPolicies
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    self.productObject.product_description = self.textView.text;
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        NSArray *array = [[Connection connection] loadPoliciesForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.policyType isEqualToString:@"Shipping Policy"]) {
                self.textView.text = [[array objectAtIndex:0] valueForKey:@"shipping_policy"];
            }else if ([self.policyType isEqualToString:@"Refunds Policy"]) {
                self.textView.text = [[array objectAtIndex:0] valueForKey:@"refunds_policy"];
            }else if ([self.policyType isEqualToString:@"Returns Policy"]) {
                self.textView.text = [[array objectAtIndex:0] valueForKey:@"returns_policy"];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (void)savePolicyChanges
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    self.productObject.product_description = self.textView.text;
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        if ([self.policyType isEqualToString:@"Shipping Policy"]) {
            [[Connection connection] didUpdateShippingPolicyForAccountId:self.textView.text];
        }else if ([self.policyType isEqualToString:@"Refunds Policy"]) {
            [[Connection connection] didUpdateRefundsPolicyForAccountId:self.textView.text];
        }else if ([self.policyType isEqualToString:@"Returns Policy"]) {
            [[Connection connection] didUpdateReturnsPolicyForAccountId:self.textView.text];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }completion:^(BOOL finished){
                [self.navigationController popViewControllerAnimated:YES];
            }];
        });
    });
}

@end
