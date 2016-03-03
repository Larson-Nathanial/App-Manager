//
//  ShippingCell.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shippingName;
@property (weak, nonatomic) IBOutlet UILabel *shippingStreet;
@property (weak, nonatomic) IBOutlet UILabel *shippingCityState;
@property (weak, nonatomic) IBOutlet UILabel *shippingZip;
@property (weak, nonatomic) IBOutlet UILabel *shippingCountry;

@end
