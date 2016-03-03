//
//  ProductObject.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject

@property (nonatomic) NSString *product_id;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *product_description;
@property (nonatomic) NSString *quantity;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *shipping;
@property (nonatomic) NSArray *images;
@property (nonatomic) NSString *shipping_policy;
@property (nonatomic) NSString *returns_policy;
@property (nonatomic) NSString *refund_policy;
@property (nonatomic) NSString *available;

- (id)initWithProductId:(NSString *)product_id category:(NSString *)category title:(NSString *)title productDescription:(NSString *)product_description quantity:(NSString *)quantity price:(NSString *)price shipping:(NSString *)shipping images:(NSArray *)images shipping_policy:(NSString *)shipping_policy returns_policy:(NSString *)returns_policy refund_policy:(NSString *)refund_policy available:(NSString *)available;

+ (id)productObjectWithProductId:(NSString *)product_id category:(NSString *)category title:(NSString *)title productDescription:(NSString *)product_description quantity:(NSString *)quantity price:(NSString *)price shipping:(NSString *)shipping images:(NSArray *)images shipping_policy:(NSString *)shipping_policy returns_policy:(NSString *)returns_policy refund_policy:(NSString *)refund_policy available:(NSString *)available;

@end
