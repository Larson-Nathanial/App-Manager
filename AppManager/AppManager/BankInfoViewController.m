//
//  BankInfoViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "BankInfoViewController.h"
#import "Connection.h"

@interface BankInfoViewController ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *bankCountry;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;

@end

@implementation BankInfoViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Bank Info";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBankInformation)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)viewWillAppear:(BOOL)animated
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
    
    [self loadBankInfo];
}

- (void)loadBankInfo
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        NSArray *array = [[Connection connection] loadBankInformationForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[[array objectAtIndex:0] valueForKey:@"bank_country"] isEqualToString:@"US"]) {
                [self.bankCountry setTitle:@"United States" forState:UIControlStateNormal];
            }else {
                [self.bankCountry setTitle:@"Canada" forState:UIControlStateNormal];
            }
            
            self.emailAddress.text = [[array objectAtIndex:0] valueForKey:@"email"];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });

}

- (void)saveBankInformation
{
    NSString *country = @"";
    if ([self.bankCountry.titleLabel.text isEqualToString:@"United States"]) {
        country = @"US";
    }else {
        country = @"CA";
    }
    NSString *email = self.emailAddress.text;
    if (email == nil || email.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email missing" message:@"You must include a valid email address in order to receive payments." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            NSArray *array = [[Connection connection] didUpdateBankAccountInfoWithEmail:email andCountry:country];
            [[Connection connection] saveStripeKeysPublic:[[array valueForKey:@"keys"] valueForKey:@"publishable"] andPrivate:[[array valueForKey:@"keys"] valueForKey:@"secret"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 0.0;
                }completion:^(BOOL finished){
                    // Alert
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Account Created" message:@"In order to finish setting up your account, you need to complete the setup of your Stripe account.  Please check your email (and junk folder) for an email from Stripe to setup your Stripe password.  You will need to connect your bank account to your stripe account in order to receive payment for the products that you sell.  If you have any questions, don't hesitate to contact us!" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }];
            });
            
        });
    }
}

- (IBAction)bankCountryAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Country" message:@"This is the country in which your bank account resides" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"United States" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.bankCountry setTitle:@"United States" forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Canada" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.bankCountry setTitle:@"Canada" forState:UIControlStateNormal];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
