//
//  CartItemCell.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *productTitle;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
- (IBAction)removeProductButtonAction:(id)sender;
@property (nonatomic, copy) void (^tappedDeleteProduct)(id sender);
@property (weak, nonatomic) IBOutlet UIButton *removeProductButtonOutlet;

@end
