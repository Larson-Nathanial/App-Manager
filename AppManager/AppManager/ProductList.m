//
//  ProductList.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "ProductList.h"
#import "SquareLayoutCell.h"
#import "Connection.h"
#import "ProductObject.h"
#import "ProductDetailsViewController.h"

@interface ProductList ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;

@property (nonatomic) NSArray *products;

@end

@implementation ProductList

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:235.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.categorySelected;
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8.0, 8.0, self.view.bounds.size.width - 16.0, self.view.bounds.size.height - 16.0) collectionViewLayout:layout];

    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    _collectionView.backgroundColor = [UIColor colorWithWhite:235.0 / 255.0 alpha:1.0];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SquareLayoutCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SquareLayoutCell class])];
    
    [self.view addSubview:_collectionView];
    
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.tintColor = [UIColor colorWithRed:244.0 / 255.0 green:88.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    
    
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createProduct)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadProducts];
}

- (void)loadProducts
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
        self.products = [NSArray arrayWithArray:[[Connection connection] loadProductsForCategoryId:self.categoryId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SquareLayoutCell class]) forIndexPath:indexPath];
    
    ProductObject *object = (ProductObject *)self.products[indexPath.row];
    
    if (object.images.count == 0) {
        
    }else {
        [cell loadImageForProductId:object.images[0]];
    }
    
    
    
    cell.layer.cornerRadius = 3.0;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.product_title.text = object.title;
    cell.product_price.text = [NSString stringWithFormat:@"$%@", object.price];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionView.bounds.size.width / 2.0 - 4.0, (_collectionView.bounds.size.width / 2.0 - 1.0) + 55.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *viewController = [ProductDetailsViewController new];
    viewController.productObject = [self.products objectAtIndex:indexPath.row];
    viewController.categorySelected = self.categorySelected;
    viewController.categoryId = self.categoryId;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)createProduct
{
    // Create product with product id and category
    
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
        NSString *product_id = [[Connection connection] createProductForCategory:self.categorySelected];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ProductObject *productObject = [ProductObject productObjectWithProductId:product_id category:self.categorySelected title:nil productDescription:nil quantity:nil price:nil shipping:nil images:nil shipping_policy:nil returns_policy:nil refund_policy:nil available:nil];
            ProductDetailsViewController *viewController = [ProductDetailsViewController new];
            viewController.productObject = productObject;
            viewController.categorySelected = self.categorySelected;
            viewController.categoryId = self.categoryId;
            [self.navigationController pushViewController:viewController animated:YES];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });

}

@end
