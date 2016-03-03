//
//  ProductsViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "ProductsViewController.h"
#import "Connection.h"
#import "ProductList.h"

@interface ProductsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) NSArray *categories;

@end

@implementation ProductsViewController

- (void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Categories";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height - 114.0) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    
    [self.view addSubview:_tableView];
    
    
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
    
    UIBarButtonItem *addCategoryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCategory)];
    self.navigationItem.rightBarButtonItem = addCategoryButton;
    [self loadCategories];
}

- (void)addCategory
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Category" message:@"Please type the name of the category" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        if (((UITextField *)alert.textFields[0]).text.length > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 1.0;
            }];
            dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(aQueue, ^{
                
                // Load Products
                [[Connection connection] didCreateCategory:((UITextField *)alert.textFields[0]).text];
                self.categories = [NSArray arrayWithArray:[[Connection connection] loadCategoriesForAccountId]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                    [UIView animateWithDuration:0.3 animations:^{
                        _coverView.alpha = 0.0;
                    }];
                });
                
            });
        }
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadCategories
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        // Load Products
        self.categories = [NSArray arrayWithArray:[[Connection connection] loadCategoriesForAccountId]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Category?" message:@"If you have products in this category, they will also be deleted. If you want to keep your products, please move them to a different category before deleting the category." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [UIView animateWithDuration:0.3 animations:^{
            _coverView.alpha = 1.0;
        }];
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            // Load Products
            [[Connection connection] didDeleteCategoryId:[[self.categories objectAtIndex:indexPath.row] valueForKey:@"id"]];
            self.categories = [NSArray arrayWithArray:[[Connection connection] loadCategoriesForAccountId]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [UIView animateWithDuration:0.3 animations:^{
                    _coverView.alpha = 0.0;
                }];
            });
            
        });
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0];
    cell.textLabel.text = [[self.categories objectAtIndex:indexPath.row] valueForKey:@"category"];
    
    UIView *aView = [UIView new];
    aView.frame = CGRectMake(5.0, 0.0, self.view.bounds.size.width - 10.0, 1.0);
    aView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    aView.tag = 54;
    [cell addSubview:aView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProductList *viewController = [ProductList new];
    viewController.categoryId = [[self.categories objectAtIndex:indexPath.row] valueForKey:@"id"];
    viewController.categorySelected = [[self.categories objectAtIndex:indexPath.row] valueForKey:@"category"];
    [self.navigationController pushViewController:viewController animated:YES];
    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"layout"] isEqualToString:@"Square"]) {
//        SquareLayout *la = [SquareLayout new];
//        la.fromSearch = YES;
//        la.titleLabelText = [[self.categories objectAtIndex:indexPath.row] valueForKey:@"category"];
//        [self.navigationController pushViewController:la animated:YES];
//    }
    
}


@end
