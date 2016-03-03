//
//  StepFive.m
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "StepFive.h"
#import "StepSix.h"
#import <Stripe/Stripe.h>

@interface StepFive ()<STPPaymentCardTextFieldDelegate>

@property(nonatomic) STPPaymentCardTextField *paymentTextField;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation StepFive

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Step 5 of 7";
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
    self.paymentTextField = [[STPPaymentCardTextField alloc] initWithFrame:CGRectMake(15, 175, self.view.bounds.size.width - 30.0, 44.0)];
    self.paymentTextField.delegate = self;
    [self.view addSubview:self.paymentTextField];
    
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

- (void)saveCardInformation
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    STPCardParams *card = [[STPCardParams alloc] init];
    card.number = self.paymentTextField.card.number;
    card.expMonth = self.paymentTextField.card.expMonth;
    card.expYear = self.paymentTextField.card.expYear;
    card.cvc = self.paymentTextField.card.cvc;
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  NSLog(@"%@", error.localizedDescription);
                                              } else {
                                                  [self createBackendChargeWithToken:token];
                                              }
                                          }];
    
}

- (void)createBackendChargeWithToken:(STPToken *)token
{
    [self.paymentTextField resignFirstResponder];
    NSURL *url = [NSURL URLWithString:@"https://www.appselevated.com/whiteLabelCreateStripeCustomerForAccountHolder.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@&account_id=%@&last_4=%@", token.tokenId, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], [self.paymentTextField.card.number  substringFromIndex: [self.paymentTextField.card.number length] - 4]];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        [self raiseNoInternetMessage];
    } else {
        
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        returnData = nil;
        
        [self.navigationController pushViewController:[StepSix new] animated:YES];
    }
    
}

- (void)raiseNoInternetMessage
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please connect to the internet and try again" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.nextOutlet.layer.cornerRadius = 3.0;
    
    if ([self.whichOption isEqualToString:@"Annual"]) {
        self.priceLabel.text = @"$700.00 / Year";
    }else {
        self.priceLabel.text = @"$75.00 / Month";
    }
}

- (IBAction)nextButtonAction:(id)sender {
    
    [self saveCardInformation];
    
}


@end
