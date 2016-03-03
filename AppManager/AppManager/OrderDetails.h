//
//  OrderDetails.h
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetails : UIViewController

@property (nonatomic) NSString *viewingAs;
@property (nonatomic) NSArray *cartItems;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *shippingAddress;
@property (nonatomic) NSString *paymentMethod;
@property (nonatomic) NSString *order_id;

@end
