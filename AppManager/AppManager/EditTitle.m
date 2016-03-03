//
//  EditTitle.m
//  AppManager
//
//  Created by Nathan Larson on 12/18/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "EditTitle.h"
#import "Connection.h"

@interface EditTitle ()

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation EditTitle

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:235.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Editing";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductChanges)];
    self.navigationItem.rightBarButtonItem = button;
    
    self.productTitleTextField.text = self.productObject.title;
    self.productPriceTextField.text = self.productObject.price;
    self.productShippingTextField.text = self.productObject.shipping;
    self.productQuantityTextField.text = self.productObject.quantity;
    
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
    
    
}

- (void)saveProductChanges
{
    if (self.productPriceTextField.text.length == 0 || self.productQuantityTextField.text.length == 0 || self.productShippingTextField.text.length == 0 || self.productTitleTextField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Info!" message:@"All fields are required in order to save." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else {
        BOOL proceed = YES;
        // sanitize the number fields.
        if ([self.productPriceTextField.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
            proceed = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Only numbers and decimals are allowed in the price field." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        if ([self.productQuantityTextField.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
            proceed = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Only numbers are allowed in the quantity field." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        if ([self.productShippingTextField.text rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location == NSNotFound) {
            proceed = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Only numbers and decimals are allowed in the shipping field." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        if (proceed) {
            
            self.productObject.title = self.productTitleTextField.text;
            self.productObject.price = self.productPriceTextField.text;
            self.productObject.shipping = self.productShippingTextField.text;
            self.productObject.quantity = self.productQuantityTextField.text;
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 1.0;
            }];
            
            dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(aQueue, ^{
                
                
                
                [[Connection connection] didUpdateProductId:self.productObject.product_id withTitle:self.productTitleTextField.text andPrice:self.productPriceTextField.text andShipping:self.productShippingTextField.text andQuantity:self.productQuantityTextField.text];
                
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
}

@end
