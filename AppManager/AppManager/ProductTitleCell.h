//
//  ProductTitleCell.h
//  SBApp
//
//  Created by Nathan Larson on 10/3/15.
//  Copyright © 2015 Nathan Larson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productFromPrice;
@property (weak, nonatomic) IBOutlet UILabel *productShipping;
@property (weak, nonatomic) IBOutlet UILabel *productQuantity;

@end
