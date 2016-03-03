//
//  CartItemCell.m
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "CartItemCell.h"

@implementation CartItemCell

- (IBAction)removeProductButtonAction:(id)sender {
    self.tappedDeleteProduct(sender);
}
@end
