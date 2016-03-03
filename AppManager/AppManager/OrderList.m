//
//  OrderList.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "OrderList.h"
#import "OrderDetails.h"
#import "Connection.h"

@interface OrderList ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSDictionary *orders;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@end

@implementation OrderList

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.whichList;
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
    
    [self.view addSubview:_tableView];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [self loadOrderHistory];
}

- (void)loadOrderHistory
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
        NSArray *array = @[];//[[Connection connection] loadOrdersForUserId];
        
        if ([self.whichList isEqualToString:@"New Orders"]) {
            array = [[Connection connection] loadNewOrdersForAccountId];
        }else {
            array = [[Connection connection] loadShippedOrdersForAccountId];
        }
        
        NSMutableArray *orderIds = [NSMutableArray new];
        for (NSArray *arr in array) {
            if (![orderIds containsObject:[arr valueForKey:@"order_id"]]) {
                [orderIds addObject:[arr valueForKey:@"order_id"]];
            }
        }
        
        NSMutableDictionary *finishedDictionary = [NSMutableDictionary new];
        for (NSString *orderId in orderIds) {
            NSMutableArray *innerArray = [NSMutableArray new];
            for (NSArray *mini in array) {
                if ([orderId isEqualToString:[mini valueForKey:@"order_id"]]) {
                    [innerArray addObject:mini];
                }
            }
            [finishedDictionary setObject:innerArray forKey:orderId];
        }
        
        self.orders = [NSDictionary dictionaryWithDictionary:finishedDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = enUSPOSIXLocale;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDate *mDate = [formatter dateFromString:[[self.orders valueForKey:[self.orders.allKeys objectAtIndex:indexPath.row]][0] valueForKey:@"creation_date"]];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterMediumStyle];
    NSString *date = [f stringFromDate:mDate];
    
    cell.textLabel.text = date; // [self.orders.allKeys objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self loadCartItems:[self.orders valueForKey:[self.orders.allKeys objectAtIndex:indexPath.row]] withOrderId:self.orders.allKeys[indexPath.row]];
}

- (void)loadCartItems:(NSArray *)cartItems withOrderId:(NSString *)order_id
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    OrderDetails *viewController = [OrderDetails new];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Cart Items
        viewController.cartItems = [NSArray arrayWithArray:[[Connection connection] loadProductsForOrderId:order_id]];
        viewController.paymentMethod = [[Connection connection] loadPaymentMethodForOrderId:order_id];
        viewController.shippingAddress = [NSArray arrayWithArray:[[Connection connection] loadShippingAddressForOrderId:order_id]];
        viewController.order_id = order_id;
        viewController.viewingAs = self.whichList;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController pushViewController:viewController animated:YES];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
    
    
    
    
}


@end
