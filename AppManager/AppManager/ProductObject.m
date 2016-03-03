//
//  ProductObject.m
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "ProductObject.h"

@implementation ProductObject

- (id)initWithProductId:(NSString *)product_id category:(NSString *)category title:(NSString *)title productDescription:(NSString *)product_description quantity:(NSString *)quantity price:(NSString *)price shipping:(NSString *)shipping images:(NSArray *)images shipping_policy:(NSString *)shipping_policy returns_policy:(NSString *)returns_policy refund_policy:(NSString *)refund_policy available:(NSString *)available
{
    self = [super init];
    if (self) {
        self.product_id = product_id;
        self.category = category;
        self.title = title;
        self.product_description = product_description;
        self.quantity = quantity;
        self.price = price;
        self.shipping = shipping;
        self.images = images;
        self.shipping_policy = shipping_policy;
        self.returns_policy = returns_policy;
        self.refund_policy = refund_policy;
        self.available = available;
    }
    return self;
}

+ (id)productObjectWithProductId:(NSString *)product_id category:(NSString *)category title:(NSString *)title productDescription:(NSString *)product_description quantity:(NSString *)quantity price:(NSString *)price shipping:(NSString *)shipping images:(NSArray *)images shipping_policy:(NSString *)shipping_policy returns_policy:(NSString *)returns_policy refund_policy:(NSString *)refund_policy available:(NSString *)available
{
    return [[self alloc] initWithProductId:product_id category:category title:title productDescription:product_description quantity:quantity price:price shipping:shipping images:images shipping_policy:shipping_policy returns_policy:returns_policy refund_policy:refund_policy available:available];
}

@end
