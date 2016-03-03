//
//  ProductDetailsViewController.m
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ImageCell.h"
#import "ProductTitleCell.h"
#import "DescriptionCell.h"
#import "ShippingPolicyCell.h"
#import "ReturnsPolicyCell.h"
#import "RefundsPolicyCell.h"
#import "Connection.h"
#import "EditTitle.h"
#import "PolicyEditor.h"
#import "CategoryCell.h"


@interface ProductDetailsViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;

@end

@implementation ProductDetailsViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Details";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height - 0.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ImageCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ImageCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductTitleCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductTitleCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DescriptionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DescriptionCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShippingPolicyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ShippingPolicyCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RefundsPolicyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RefundsPolicyCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReturnsPolicyCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReturnsPolicyCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CategoryCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CategoryCell class])];
    
    [self.view addSubview:_tableView];
    
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:0.8];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewingFromOrder) {
        return 7;
    }
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row == 0) { // Image
            return self.view.bounds.size.width + 37.0;
        }else if (indexPath.row == 1) { // Add To Cart
            return 60.0;
        }else if (indexPath.row == 3) {
            CGSize size = [self.productObject.product_description boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 40.0, MAXFLOAT)
                                                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                         attributes:@{
                                                                                                                      NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
                                                                                                                      }
                                                                                                            context:nil].size;
            
            return size.height + 50.0;
        }else if (indexPath.row == 4) {
            CGSize size = [self.productObject.shipping_policy boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 40.0, MAXFLOAT)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:@{
                                                                                                           NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
                                                                                                           }
                                                                                                 context:nil].size;
            
            return size.height + 50.0;
        }else if (indexPath.row == 5) {
            CGSize size = [self.productObject.returns_policy boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 40.0, MAXFLOAT)
                                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{
                                                                                                          NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
                                                                                                          }
                                                                                                context:nil].size;
            
            return size.height + 50.0;
        }else if (indexPath.row == 6) {
            CGSize size = [self.productObject.refund_policy boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 40.0, MAXFLOAT)
                                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{
                                                                                                          NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:16.0]
                                                                                                          }
                                                                                                context:nil].size;
            
            return size.height + 50.0;
        }else if (indexPath.row == 7) {
            return 80.0;
        }

    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row == 0) {
            ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImageCell class]) forIndexPath:indexPath];
            
            if (self.viewingFromOrder) {
                cell.showDeleteButton = NO;
            }else {
                cell.showDeleteButton = YES;
            }
            [cell loadImages:self.productObject.images];
            
            // Put add button overlaying the top of the images, in the bottom right.
            
            if (!self.viewingFromOrder) {
                [[cell viewWithTag:855] removeFromSuperview];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(cell.frame.size.width - 49.0, cell.frame.size.height - 49.0, 44.0, 44.0);
                button.tag = 855;
                button.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:@"+" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:36.0]];
                [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
                button.layer.cornerRadius = 2.0;
                
                [cell addSubview:button];

            }
            
            
            cell.deleteImage = ^(id sender) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 1.0;
                }];
                
                dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(aQueue, ^{
                    
                    [[Connection connection] didDeleteProductImageWithFileName:self.productObject.images[((UIButton *)sender).tag]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        [UIView animateWithDuration:0.3 animations:^{
                            _coverView.alpha = 0.0;
                        }];
                    });
                    
                });
                
            };
            
            return cell;
            
        }else if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
            
            cell.accessoryView = nil;
            
            UISwitch *sw = [UISwitch new];
            sw.frame = CGRectMake(0.0, 0.0, 100.0, 30.0);
            if (self.productObject.available.intValue == 1) {
                sw.on = YES;
            }else {
                sw.on = NO;
            }
            [sw addTarget:self action:@selector(madeProductAvailable) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = sw;
            
            cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
            cell.textLabel.text = @"Ready for sale?";
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 1) {
            ProductTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductTitleCell class]) forIndexPath:indexPath];
            
            cell.productTitleLabel.text = self.productObject.title;
            cell.productFromPrice.text = [NSString stringWithFormat:@"$%@", self.productObject.price];
            cell.productShipping.text = [NSString stringWithFormat:@"$%@", self.productObject.shipping];
            cell.productQuantity.text = self.productObject.quantity;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 3) {
            DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DescriptionCell class]) forIndexPath:indexPath];
            
            cell.productDescriptionLabel.text = self.productObject.product_description;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 4) {
            ShippingPolicyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShippingPolicyCell class]) forIndexPath:indexPath];
            
            cell.shippingPolicyLabel.text = self.productObject.shipping_policy;
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 5) {
            ReturnsPolicyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReturnsPolicyCell class]) forIndexPath:indexPath];
            
            cell.returnsPolicyLabel.text = self.productObject.returns_policy;
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 6) {
            RefundsPolicyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RefundsPolicyCell class]) forIndexPath:indexPath];
            
            cell.refundPolicyLabel.text = self.productObject.refund_policy;
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 7) {
            CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CategoryCell class]) forIndexPath:indexPath];
            
            [[cell viewWithTag:855] removeFromSuperview];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(5.0, cell.frame.size.height - 50.0, cell.frame.size.width - 10.0, 45.0);
            button.tag = 855;
            button.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:self.categorySelected forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18.0]];
            [button addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 2.0;
            
            [cell addSubview:button];
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }else if (indexPath.row == 8) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
            
            [[cell viewWithTag:855] removeFromSuperview];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(5.0, cell.frame.size.height - 55.0, cell.frame.size.width - 10.0, 50.0);
            button.tag = 855;
            button.backgroundColor = [UIColor redColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"Delete" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:18.0]];
            [button addTarget:self action:@selector(deleteProduct) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 2.0;
            
            [cell addSubview:button];
            
            [[cell viewWithTag:54] removeFromSuperview];
            
            UIView *aView = [UIView new];
            aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
            aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
            aView.tag = 54;
            [cell addSubview:aView];
            
            return cell;
        }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        EditTitle *viewController = [EditTitle new];
        viewController.productObject = self.productObject;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 3) {
        PolicyEditor *viewController = [PolicyEditor new];
        viewController.policyType = @"Description";
        viewController.productObject = self.productObject;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)madeProductAvailable
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        if (self.productObject.available.intValue == 1) {
            [[Connection connection] didUpdateAvailabilityOfProductWithAvailability:@"0" forProductId:self.productObject.product_id];
        }else {
            [[Connection connection] didUpdateAvailabilityOfProductWithAvailability:@"1" forProductId:self.productObject.product_id];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.productObject.available.intValue == 1) {
                self.productObject.available = @"0";
            }else {
                self.productObject.available = @"1";
            }
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (void)changeCategory
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Get all categories for this product.
        NSArray *categories = [[Connection connection] loadCategoriesForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Category" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            for (NSDictionary *dictionary in categories) {
                [alert addAction:[UIAlertAction actionWithTitle:[dictionary valueForKey:@"category"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [UIView animateWithDuration:0.3 animations:^{
                        _coverView.alpha = 1.0;
                    }];
                    
                    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(aQueue, ^{
                        
                        [[Connection connection] didUpdateProductId:self.productObject.product_id withCategoryId:[dictionary valueForKey:@"id"]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                _coverView.alpha = 0.0;
                            }completion:^(BOOL finished){
                                
                            }];
                        });
                        
                    });
                }]];
            }
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (void)deleteProduct
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Product?" message:@"You cannot undo this action" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            [[Connection connection] didDeleteProductId:self.productObject.product_id];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 0.0;
                }completion:^(BOOL finished){
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        });
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addToCartSelected
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
//        [[Connection connection] addProductToCart:self.productObject.product_id];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

#pragma mark - For the Images

- (void)addPhoto
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Image" message:@"Choose an option" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self showPhotoLibrary];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self showCamera];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showCamera
{
    if (![self startCameraControllerFromViewController: self
                                         usingDelegate: self]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your camera is not available." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showPhotoLibrary
{
    if (![self startMediaBrowserFromViewController: self
                                     usingDelegate: self]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your photo library is not available." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = self;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    //    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
    //        == kCFCompareEqualTo) {
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        if (imageToSave != nil) {
            //  - send it off to be saved, base64encode it as a string, reload the images.
            
            NSData *imageData = UIImageJPEGRepresentation(imageToSave, 1.0);
            NSString *post = [imageData base64EncodedStringWithOptions:kNilOptions];
            post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            
           
            if (![[Connection connection] didInsertNewProductImage:post forProductId:self.productObject.product_id]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your image didn't save, please try again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        
                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [UIView animateWithDuration:0.5 animations:^{
                        _coverView.alpha = 0.0;
                    }];
                });
            }
            
            NSArray *products = [[Connection connection] loadProductsForCategoryId:self.categoryId];
            for (ProductObject *object in products) {
                if (object.product_id.intValue == self.productObject.product_id.intValue) {
                    self.productObject = object;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [picker dismissViewControllerAnimated:YES completion:nil];
                [self.tableView reloadData];
                [UIView animateWithDuration:0.5 animations:^{
                    _coverView.alpha = 0.0;
                }];
            });
            
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must select an image." preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:nil];
                
//                [self loadProductDetails];
                [UIView animateWithDuration:0.5 animations:^{
                    _coverView.alpha = 0.0;
                }];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [picker dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
        
        
    });
    
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypePhotoLibrary];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = self;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}


@end
