//
//  TotalCell.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subtotal;
@property (weak, nonatomic) IBOutlet UILabel *shipping;
@property (weak, nonatomic) IBOutlet UILabel *grandtotal;

@end
