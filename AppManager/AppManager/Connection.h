//
//  Connection.h
//  AppManager
//
//  Created by Nathan Larson on 12/18/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Connection : NSObject

+ (Connection *)connection;

- (NSArray *)loadCategoriesForAccountId;
- (NSArray *)loadProductsForCategoryId:(NSString *)category_id;
- (BOOL)didCreateCategory:(NSString *)category;
- (BOOL)didDeleteCategoryId:(NSString *)category_id;
- (BOOL)didUpdateAvailabilityOfProductWithAvailability:(NSString *)availability forProductId:(NSString *)product_id;
- (BOOL)didUpdateProductId:(NSString *)product_id withTitle:(NSString *)product_title andPrice:(NSString *)price andShipping:(NSString *)shipping andQuantity:(NSString *)quantity;
- (BOOL)didUpdateProductId:(NSString *)product_id withDescription:(NSString *)product_description;
- (BOOL)didUpdateProductId:(NSString *)product_id withCategoryId:(NSString *)category_id;
- (BOOL)didDeleteProductId:(NSString *)product_id;
- (BOOL)didInsertNewProductImage:(NSString *)product_image forProductId:(NSString *)product_id;
- (BOOL)didDeleteProductImageWithFileName:(NSString *)file_name;
- (NSString *)createProductForCategory:(NSString *)category;
- (NSArray *)loadNewOrdersForAccountId;
- (NSArray *)loadShippedOrdersForAccountId;
- (NSArray *)loadProductsForOrderId:(NSString *)order_id;
- (NSArray *)loadShippingAddressForOrderId:(NSString *)order_id;
- (NSString *)loadPaymentMethodForOrderId:(NSString *)order_id;
- (BOOL)markOrderIdAsShipped:(NSString *)order_id;

// Stats Methods
- (NSString *)getCountOfDownloadsForAccountId;
- (NSString *)getCountOfActiveUsersForAccountId;

// Account Methods
- (BOOL)didUpdateAccountIdWithBusinessName:(NSString *)business_name firstName:(NSString *)first_name lastName:(NSString *)last_name phoneNumber:(NSString *)phone_number email:(NSString *)email;
- (NSArray *)loadAccountInformationForAccountId;

// Plan Info Methods
- (NSArray *)loadPlanInformationForAccountId;

// Bank Info Methods
- (NSArray *)loadBankInformationForAccountId;
- (NSArray *)didUpdateBankAccountInfoWithEmail:(NSString *)email andCountry:(NSString *)country;
- (BOOL)saveStripeKeysPublic:(NSString *)public_key andPrivate:(NSString *)private_key;

// Policies Methods
- (NSArray *)loadPoliciesForAccountId;
- (BOOL)didUpdateShippingPolicyForAccountId:(NSString *)shipping_policy;
- (BOOL)didUpdateReturnsPolicyForAccountId:(NSString *)returns_policy;
- (BOOL)didUpdateRefundsPolicyForAccountId:(NSString *)refunds_policy;

// Login Methods
- (NSString *)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (BOOL)didSetAccountIdForEmail:(NSString *)email;
- (BOOL)didCreateAccountForEmail:(NSString *)email andPassword:(NSString *)password;

// Setup Steps
- (BOOL)didUpdateBusinessName:(NSString *)business_name;
- (BOOL)didUpdateFirstName:(NSString *)first_name andLastName:(NSString *)last_name;
- (BOOL)didUpdatePhoneNumber:(NSString *)phone_number;
- (BOOL)didUpdatePlan:(NSString *)plan_chosen;
- (BOOL)didUpdateBankCountry:(NSString *)bank_country;

@end
