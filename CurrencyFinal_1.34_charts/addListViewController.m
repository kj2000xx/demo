//
//  addListViewController.m
//  Currency
//
//  Created by Shane on 2016/5/1.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "addListViewController.h"
#import "AddlistTableViewCell.h"
#import <CoreGraphics/CoreGraphics.h>
@interface addListViewController()<UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic)NSDictionary *addList_Dic;
@property (nonatomic)NSArray *nameEN_arr;
@property (nonatomic)NSArray *nameCn_arr;

@property(nonatomic)NSArray *result_arr;
@property(nonatomic) UISearchController *searchController;

@end

@implementation addListViewController

#pragma mark View animated
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    //[[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0.1];//透明度
    
    //presentView anmation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //transition.type = kCATransitionReveal;
    //transition.type =@"rippleEffect";
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.addList_Dic =@{
                        @"USD":@"美金",@"HKD":@"港幣",
                        @"GBP":@"英鎊",@"AUD":@"澳幣",
                        @"CAD":@"加拿大幣",@"SGD":@"新加坡幣",
                        @"CHF":@"瑞士法郎",@"JPY":@"日圓",
                        @"ZAR":@"南非幣",@"SEK":@"瑞典幣",
                        @"NZD":@"紐元",@"THB":@"泰幣",
                        @"PHP":@"菲國比索",@"IDR":@"印尼幣",
                        @"EUR":@"歐元",@"KRW":@"韓元",
                        @"VND":@"越南盾",@"MYR":@"馬來幣",
                        @"CNY":@"人民幣",@"TWD":@"台幣",
                        };
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSMutableArray *loadEN = [[self.addList_Dic allKeys] mutableCopy];
    self.nameEN_arr = [loadEN sortedArrayUsingSelector:@selector(compare:)];
    self.tableView.rowHeight = 50;
    
    [self configureSearchBarController];
    self.definesPresentationContext = YES;
}

-(void)configureSearchBarController{
    //searchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;

    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    self.searchController.searchBar.placeholder = @"請輸入貨幣名稱";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
//    self.tableView.contentInset = UIEdgeInsetsZero;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.searchController.searchBar sizeToFit];
    
//    self.navigationItem.searchController = self.searchController;

//    self.tableView.tableHeaderView = self.searchController.searchBar;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
}

#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.isActive) {
       return self.result_arr.count;
    }else{
    return self.addList_Dic.count;
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddlistTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"List" forIndexPath:indexPath];
    
    if (self.searchController.isActive) {
        cell.eng_label.text = self.result_arr[indexPath.row];
        cell.eng_label.adjustsFontSizeToFitWidth = YES;
        
        NSString *cn_str = [self.addList_Dic objectForKey:self.result_arr[indexPath.row]];
        NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png",self.result_arr[indexPath.row]];
        cell.flag_imageView.image =[UIImage imageNamed:imageName];
        
        cell.cn_label.text = cn_str;
        cell.cn_label.adjustsFontSizeToFitWidth = YES;
        return cell;
    }else{
    NSString *cn_str = [self.addList_Dic objectForKey:self.nameEN_arr[indexPath.row]];
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png",self.nameEN_arr[indexPath.row]];
    cell.flag_imageView.image =[UIImage imageNamed:imageName];
        
    cell.eng_label.text = self.nameEN_arr[indexPath.row];
    cell.eng_label.adjustsFontSizeToFitWidth = YES;
        
    cell.cn_label.text = cn_str;
    cell.cn_label.adjustsFontSizeToFitWidth = YES;
    return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:0.5  animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
     */
    
    cell.layer.transform = CATransform3DMakeTranslation(200, 0, 0);
    
    [UIView animateWithDuration:0.3 animations:^{

        cell.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
     
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddlistTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.searchController.searchBar removeFromSuperview];
    
    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
    NSMutableArray *favorListName = [[userDefault objectForKey:@"favorListName_Arr"] mutableCopy];
    NSString *newListName = cell.eng_label.text;
    [favorListName addObject:newListName];
    [userDefault setObject:favorListName forKey:@"favorListName_Arr"];
    [userDefault synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"addCell" object:nil userInfo:@{@"addCountryName":newListName}];
}

#pragma mark searchBar
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    if (searchController.isActive) {
        NSString *searchString = searchController.searchBar.text;
        if ([searchString length]> 0) {
            NSPredicate *p =[NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchString];
            self.result_arr = [self.nameEN_arr filteredArrayUsingPredicate:p];
        }else{
            self.result_arr = nil;
        }
        
    }else{
        self.result_arr =nil;
        
    }
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
