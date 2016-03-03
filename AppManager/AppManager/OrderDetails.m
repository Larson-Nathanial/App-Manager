//
//  OrderDetails.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "OrderDetails.h"
#import "CartItemCell.h"
#import "ShippingCell.h"
#import "TotalCell.h"
#import "ProductObject.h"
#import "PersistentContainers.h"
#import "ProductDetailsViewController.h"
#import "Connection.h"

@interface OrderDetails ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *noCartItemsView;
@property (nonatomic) NSString *totalInCents;

@end

@implementation OrderDetails

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Details";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CartItemCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CartItemCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShippingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShippingCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TotalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TotalCell class])];
    
    
    [self.view addSubview:_tableView];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.cartItems.count;
    }else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.viewingAs isEqualToString:@"Shipped Orders"]) {
        return 4;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4|| indexPath.section == 5) {
        return 60.0;
    }else if (indexPath.section == 3) {
        return 117.0;
    }else if (indexPath.section == 2) {
        return 50.0;
    }else if (indexPath.section == 1) {
        return 141.0;
    }else {
        return 180.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // items
        
        CartItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CartItemCell class]) forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.removeProductButtonOutlet.alpha = 0.0;
        
        ProductObject *object = [self.cartItems objectAtIndex:indexPath.row];
        
        cell.tappedDeleteProduct = ^(id sender) {
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 1.0;
            }];
            
            dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(aQueue, ^{
                
                // Load Products
//                [[Connection connection] didRemoveProductIdFromCart:object.product_id];
//                self.cartItems = [[Connection connection] loadProductsInCartForUserId];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        _coverView.alpha = 0.0;
                    }];
                });
                
            });
            
            
        };
        
        
        
        cell.productTitle.text = object.title;
        cell.productPrice.text = [NSString stringWithFormat:@"$%@", object.price];
        cell.productDescription.text = object.product_description;
        
        if ([[[PersistentContainers persistentContainers] imagesDictionary] objectForKey:object.images[0]]) {
            
            cell.productImage.image = [[[PersistentContainers persistentContainers] imagesDictionary] objectForKey:object.images[0]];
            
            
        }else {
            
            dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(aQueue, ^{
                
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/%@", object.images[0]]];
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.productImage.image = [[UIImage alloc] initWithData:data];
                        [[[PersistentContainers persistentContainers] imagesDictionary] setObject:[[UIImage alloc] initWithData:data] forKey:object.images[0]];
                    });
                }
            });
        }
        
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        aView.tag = 54;
        [cell addSubview:aView];
        
        return cell;
        
    }else if (indexPath.section == 1) { // Shipping
        
        ShippingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShippingCell class]) forIndexPath:indexPath];
        
        cell.shippingName.text = [[self.shippingAddress objectAtIndex:0] valueForKey:@"ship_to_name"];
        cell.shippingStreet.text = [[self.shippingAddress objectAtIndex:0] valueForKey:@"street"];
        cell.shippingCityState.text = [NSString stringWithFormat:@"%@, %@", [[self.shippingAddress objectAtIndex:0] valueForKey:@"city"], [[self.shippingAddress objectAtIndex:0] valueForKey:@"state"]];
        cell.shippingZip.text = [[self.shippingAddress objectAtIndex:0] valueForKey:@"zip"];
        cell.shippingCountry.text = [[self.shippingAddress objectAtIndex:0] valueForKey:@"country"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        aView.tag = 54;
        [cell addSubview:aView];
        
        return cell;
        
    }else if (indexPath.section == 2) { // Payment
        
        // Payment information is going to be stored in database. Default payment is whatever was used last, it's an array containing the last 4 + id of the row to use.
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        
        
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
            cell.textLabel.text = self.paymentMethod;
            
        
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        aView.tag = 54;
        [cell addSubview:aView];
        
        return cell;
        
    }else if (indexPath.section == 3) { // Sub-total + Shipping + total.
        
        TotalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TotalCell class]) forIndexPath:indexPath];
        
        // sum up the sub total and shipping.
        float products = 0.00;
        float shipping = 0.00;
        float grandTotal= 0.00;
        
        for (ProductObject *object in self.cartItems) {
            products = products + object.price.floatValue;
            shipping = shipping + object.shipping.floatValue;
        }
        
        grandTotal = products + shipping;
        
        cell.subtotal.text = [NSString stringWithFormat:@"$%.2f", products];
        cell.shipping.text = [NSString stringWithFormat:@"$%.2f", shipping];
        cell.grandtotal.text = [NSString stringWithFormat:@"$%.2f", grandTotal];
        
        self.totalInCents = [NSString stringWithFormat:@"%.0f", grandTotal * 100.0];
        
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        aView.tag = 54;
        [cell addSubview:aView];
        
        return cell;
        
    }else { // Pay Now button
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
        
        [[cell viewWithTag:645] removeFromSuperview];
        
        UIButton *checkoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        checkoutButton.frame = CGRectMake(8.0, 8.0, self.view.bounds.size.width - 16.0, 44.0);
        [checkoutButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:24.0]];
        [checkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkoutButton.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
        [checkoutButton setTitle:@"Shipped" forState:UIControlStateNormal];
        [checkoutButton setTag:645];
        
        [checkoutButton addTarget:self action:@selector(shippedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:checkoutButton];
        
        UIView *aView = [UIView new];
        aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
        aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        aView.tag = 54;
        [cell addSubview:aView];
        
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        ProductDetailsViewController *viewController = [ProductDetailsViewController new];
        viewController.productObject = [self.cartItems objectAtIndex:indexPath.row];
        viewController.viewingFromOrder = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
//    if (indexPath.section == 1) { // Shipping
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"default_shipping"] == nil) {
//            [self.delegate addNewShippingAddress];
//        }else {
//            [self.delegate selectShippingAddress];
//        }
//        
//    }else if (indexPath.section == 2) { // Payment Information
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"default_payment"] == nil) {
//            [self.delegate addNewPaymentMethod];
//        }else {
//            [self.delegate selectPaymentMethod];
//        }
//        
//    }
}

- (void)shippedButtonPressed
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        [[Connection connection] markOrderIdAsShipped:self.order_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}



@end
