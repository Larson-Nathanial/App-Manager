//
//  Connection.m
//  AppManager
//
//  Created by Nathan Larson on 12/18/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "Connection.h"
#import "ProductObject.h"

@interface Connection ()

@property (nonatomic) NSString *verification;

@end

@implementation Connection

+ (Connection *)connection
{
    static Connection *connection = nil;

    if (!connection) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            connection = [[self alloc] initPrivate];
        });
    }
    return connection;
}

- (instancetype)initPrivate
{
    self = [super init];
    _verification = @"a verification string....";
    return self;
}

- (NSArray *)loadCategoriesForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadCategories.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadProductsForCategoryId:(NSString *)category_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&category_id=%@&account_id=%@", _verification, category_id, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadProductsForCategory.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                NSMutableArray *returnableObjects = [NSMutableArray new];
                
                for (NSArray *array in returnData) {
                    NSMutableArray *images = [NSMutableArray new];
                    for (int i = 1; i <= array.count - 1; i++) {
                        [images addObject:[[array valueForKey:[NSString stringWithFormat:@"Image_%i", i]] valueForKey:@"file_name"]];
                    }
                    
                    ProductObject *object = [ProductObject productObjectWithProductId:[[array valueForKey:@"Data"] valueForKey:@"id"] category:[[array valueForKey:@"Data"] valueForKey:@"category"] title:[[array valueForKey:@"Data"] valueForKey:@"title"] productDescription:[[array valueForKey:@"Data"] valueForKey:@"description"] quantity:[[array valueForKey:@"Data"] valueForKey:@"quantity"] price:[[array valueForKey:@"Data"] valueForKey:@"price"] shipping:[[array valueForKey:@"Data"] valueForKey:@"shipping"] images:images shipping_policy:[[array valueForKey:@"Data"] valueForKey:@"shipping_policy"] returns_policy:[[array valueForKey:@"Data"] valueForKey:@"returns_policy"] refund_policy:[[array valueForKey:@"Data"] valueForKey:@"refunds_policy"] available:[[array valueForKey:@"Data"] valueForKey:@"available"]];
                    
                    [returnableObjects addObject:object];
                }
                return returnableObjects;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (BOOL)didCreateCategory:(NSString *)category
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&category=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], category];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/AddCategory.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didDeleteCategoryId:(NSString *)category_id
{
    
        NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&category_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], category_id];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/DeleteCategory.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        if (responseData == nil) {
            return NO;
        }else {
            NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
            
            if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
                
                if (returnString.length > 0) {
                    return YES;
                }else {
                    return NO;
                }
            }
        }
        return NO;
    

}

- (BOOL)didUpdateAvailabilityOfProductWithAvailability:(NSString *)availability forProductId:(NSString *)product_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&product_id=%@&availability=%@", _verification, product_id, availability];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateProductAvailability.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateProductId:(NSString *)product_id withTitle:(NSString *)product_title andPrice:(NSString *)price andShipping:(NSString *)shipping andQuantity:(NSString *)quantity
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&product_id=%@&product_title=%@&price=%@&shipping=%@&quantity=%@", _verification, product_id, product_title, price, shipping, quantity];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateProductTitle.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateProductId:(NSString *)product_id withDescription:(NSString *)product_description
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&product_id=%@&product_description=%@", _verification, product_id, product_description];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateProductDescription.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateProductId:(NSString *)product_id withCategoryId:(NSString *)category_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&product_id=%@&category_id=%@", _verification, product_id, category_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateProductCategory.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didDeleteProductId:(NSString *)product_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&product_id=%@", _verification, product_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/DeleteProduct.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didInsertNewProductImage:(NSString *)product_image forProductId:(NSString *)product_id
{
    NSString *account_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"];
    
    NSString *image_name = [[NSUUID UUID] UUIDString];
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&image=%@&image_name_one=%@&product_id=%@", _verification, account_id, product_image, image_name, product_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/InsertProductImage.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didDeleteProductImageWithFileName:(NSString *)file_name
{
    
    NSString *post = [NSString stringWithFormat:@"verify=%@&file_name=%@", _verification, file_name];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/DeleteProductImage.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSString *)createProductForCategory:(NSString *)category
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&category=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], category];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/CreateProduct.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            if (returnString.length > 0) {
                return returnString;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadNewOrdersForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadNewOrders.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadShippedOrdersForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadShippedOrders.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadProductsForOrderId:(NSString *)order_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&order_id=%@", _verification, order_id];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadProductsForOrderId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                NSMutableArray *returnableObjects = [NSMutableArray new];
                
                for (NSArray *array in returnData) {
                    NSMutableArray *images = [NSMutableArray new];
                    for (int i = 1; i <= array.count - 1; i++) {
                        [images addObject:[[array valueForKey:[NSString stringWithFormat:@"Image_%i", i]] valueForKey:@"file_name"]];
                    }
                    
                    ProductObject *object = [ProductObject productObjectWithProductId:[[array valueForKey:@"Data"] valueForKey:@"id"] category:[[array valueForKey:@"Data"] valueForKey:@"category"] title:[[array valueForKey:@"Data"] valueForKey:@"title"] productDescription:[[array valueForKey:@"Data"] valueForKey:@"description"] quantity:[[array valueForKey:@"Data"] valueForKey:@"quantity"] price:[[array valueForKey:@"Data"] valueForKey:@"price"] shipping:[[array valueForKey:@"Data"] valueForKey:@"shipping"] images:images shipping_policy:[[array valueForKey:@"Data"] valueForKey:@"shipping_policy"] returns_policy:[[array valueForKey:@"Data"] valueForKey:@"returns_policy"] refund_policy:[[array valueForKey:@"Data"] valueForKey:@"refunds_policy"] available:[[array valueForKey:@"Data"] valueForKey:@"available"]];
                    
                    [returnableObjects addObject:object];
                }
                
                return returnableObjects;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadShippingAddressForOrderId:(NSString *)order_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&order_id=%@", _verification, order_id];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadShippingAddressForOrder.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSString *aString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)loadPaymentMethodForOrderId:(NSString *)order_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&order_id=%@", _verification, order_id];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadPaymentMethodForOrder.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            if (returnString.length > 0) {
                return [NSString stringWithFormat:@"CARD ...%@", returnString];
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (BOOL)markOrderIdAsShipped:(NSString *)order_id
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&order_id=%@", _verification, order_id];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/MarkOrderIdAsShipped.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSString *)getCountOfDownloadsForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/GetCountOfDownloads.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            if (returnString.length > 0) {
                return returnString;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSString *)getCountOfActiveUsersForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/GetCountOfActiveUsers.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            if (returnString.length > 0) {
                return returnString;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (BOOL)didUpdateAccountIdWithBusinessName:(NSString *)business_name firstName:(NSString *)first_name lastName:(NSString *)last_name phoneNumber:(NSString *)phone_number email:(NSString *)email
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&business_name=%@&first_name=%@&last_name=%@&phone_number=%@&email=%@&account_id=%@", _verification, business_name, first_name, last_name, phone_number, email, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateAccountId.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSArray *)loadAccountInformationForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadAccountInfo.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];

        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadPlanInformationForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadPlanInfo.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];

        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)loadBankInformationForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadBankInfo.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    
    return nil;
}

- (NSArray *)didUpdateBankAccountInfoWithEmail:(NSString *)email andCountry:(NSString *)country
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&email=%@&country=%@", self.verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], email, country];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/UpdateBankAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];

        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    return nil;
}

- (BOOL)saveStripeKeysPublic:(NSString *)public_key andPrivate:(NSString *)private_key
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&public_key=%@&private_key=%@&account_id=%@", _verification, public_key, private_key, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateStripeKeysForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSArray *)loadPoliciesForAccountId
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@", self.verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoadAccountPolicies.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnData.count > 0) {
                
                return returnData;
            }else {
                return nil;
            }
        }
    }
    return nil;
}

- (BOOL)didUpdateShippingPolicyForAccountId:(NSString *)shipping_policy
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&shipping_policy=%@&account_id=%@", _verification, shipping_policy, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateShippingPolicyForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateReturnsPolicyForAccountId:(NSString *)returns_policy
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&returns_policy=%@&account_id=%@", _verification, returns_policy, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateReturnsPolicyForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateRefundsPolicyForAccountId:(NSString *)refunds_policy
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&refunds_policy=%@&account_id=%@", _verification, refunds_policy, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"]];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateRefundsPolicyForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (NSString *)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&email=%@&password=%@", self.verification, email, password];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/LoginUser.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return nil;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                
                return returnString;
            }else {
                return nil;
            }
        }
    }
    return nil;
}

- (BOOL)didSetAccountIdForEmail:(NSString *)email
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&email=%@", _verification, email];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/GetAccountIdForEmail.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                [[NSUserDefaults standardUserDefaults] setValue:returnString forKey:@"account_id"];
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didCreateAccountForEmail:(NSString *)email andPassword:(NSString *)password
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&email=%@&password=%@", _verification, email, password];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/CreateNewAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                [[NSUserDefaults standardUserDefaults] setValue:returnString forKey:@"account_id"];
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateBusinessName:(NSString *)business_name
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&business_name=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], business_name];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateBusinessNameForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateFirstName:(NSString *)first_name andLastName:(NSString *)last_name
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&first_name=%@&last_name=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], first_name, last_name];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdateFirstNameAndLastNameForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;

}

- (BOOL)didUpdatePhoneNumber:(NSString *)phone_number
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&phone_number=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], phone_number];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdatePhoneNumberForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdatePlan:(NSString *)plan_chosen
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&plan_chosen=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], plan_chosen];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/WLAppCustomer/UpdatePlanForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

- (BOOL)didUpdateBankCountry:(NSString *)bank_country
{
    NSString *post = [NSString stringWithFormat:@"verify=%@&account_id=%@&bank_country=%@", _verification, [[NSUserDefaults standardUserDefaults] valueForKey:@"account_id"], bank_country];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/UpdateBankCountryForAccount.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (responseData == nil) {
        return NO;
    }else {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        [self saveStripeKeysPublic:[[array valueForKey:@"keys"] valueForKey:@"publishable"] andPrivate:[[array valueForKey:@"keys"] valueForKey:@"secret"]];
        NSString *returnString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
            
            if (returnString.length > 0) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}



@end
