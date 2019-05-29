//
//  ViewController.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/4.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"
#import "MyCollectionViewCell.h"
#import "YahooCurrencyRateLoader.h"
#import "OptionTableViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,CAAnimationDelegate>
{
    CustomTableViewCell *cellVC;
}

//currency's table list
@property (weak, nonatomic) IBOutlet UITableView *talbeView;
//currency's chart view
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


//save tableView and colloectionView's  original frame or center point
@property CGRect tableViewFrameDefault;
@property CGPoint collectionViewCenterDefault;

@property(nonatomic) NSDictionary *currencyList_Dic ;

@property(nonatomic)NSMutableDictionary *collectionOptionTitleDict;

@property(nonatomic)NSString *optionHeaderStr;

@property(nonatomic)CustomTableViewCell *selectedCell;

@property(nonatomic)YahooCurrencyRateLoader *yahooCurrencyRateLoader;

@property(nonatomic)UIActivityIndicatorView *loadingView;

@property(nonatomic) BOOL firstTimeAppearView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _yahooCurrencyRateLoader = [YahooCurrencyRateLoader new];
    [_yahooCurrencyRateLoader loadYahooCurrency];

    self.talbeView.delegate = self ;
    self.talbeView.dataSource = self ;
    self.talbeView.estimatedRowHeight = 62;
    self.talbeView.rowHeight = UITableViewAutomaticDimension;
    
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;

    
    self.userKeyIn_Arr = [NSArray new];
    self.favorListName_Arr = [NSMutableArray new];
    self.favorListRate_Dic =[NSMutableDictionary new];
    self.collectionOptionTitleDict = [NSMutableDictionary new];
    
    self.favorListName_Arr = [self getUserFavorListName_Arr];
    self.userKeyIn_Arr = [self getUserKeyIn_Arr];
    self.favorListRate_Dic =[self getFavoritListRate_Dic];
    
    [self setRangeForURL_str];
    self.optionHeaderStr = [self getOptionHeaderStr];
    
    
    [self setNavigationBar];
    
    //Navigation Bar put in logo.
    UIImage * titleImage = [UIImage imageNamed:@"title_moneyBag"];
    UIImageView *navigationImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    navigationImage.image = titleImage;
    
    UIImageView *workaroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [workaroundImageView addSubview:navigationImage];
    self.navigationItem.titleView = workaroundImageView ;
    
//    UIImage *menu_img = [self scaleImage:[UIImage imageNamed:@"menu3.png"] toScale:0.07];
    
    UIImage *menu_img = [self transImageSize:[UIImage imageNamed:@"menu3.png"] toWidth:25 toHeight:30];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.image = menu_img;

//    show path
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
            NSLog(@"%@",path);
    
 
    
    //用來比對英文國名撈出中文國名
    self.currencyList_Dic =@{
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
    
    //更新歷史匯率
        NSArray *countryNameArr = [[NSArray alloc] initWithArray:self.favorListName_Arr];
    [_yahooCurrencyRateLoader loadYahooHistoricalDataNew:countryNameArr keyInCountry:nil];
    
    //app第一次顯示首頁
    self.firstTimeAppearView = true;
    
    //add notification
    [self addNotifiCation];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadCell" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addCell" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadCollectionCell" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"renewOptionHeader" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //save Default's Frame 紀錄最原始的tableView、collectionView的frame與座標，供之後點擊時的縮放動畫使用
    self.tableViewFrameDefault = self.talbeView.frame;
    self.collectionViewCenterDefault = self.collectionView.center;
    
    if (self.firstTimeAppearView) {
        [self creatLoadingView];
        [self startLoadingView];
        _firstTimeAppearView = false;
    }
    
    [self.talbeView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.favorListName_Arr = [self getUserFavorListName_Arr];
    self.userKeyIn_Arr = [self getUserKeyIn_Arr];
    self.favorListRate_Dic =[self getFavoritListRate_Dic];
    
    //轉場動畫
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

//更改uiimage比例
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

- (UIImage *)transImageSize:(UIImage *)image toWidth:(float)width toHeight:(float)heigh{
    
    UIGraphicsBeginImageContext(CGSizeMake(width, heigh));
    [image drawInRect:CGRectMake( 0, 3, width, heigh)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}


#pragma mark Indicator startAnimating & stopAnimating
-(void)creatLoadingView{
    //loading圖示
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    _loadingView.frame = CGRectMake(self.collectionView.frame.origin.x + 5 ,self.collectionView.frame.origin.y + 5,self.collectionView.frame.size.width-10, self.collectionView.frame.size.height-10);
    
    _loadingView.backgroundColor = [UIColor grayColor];
    _loadingView.layer.cornerRadius = 15;
    
    
    _loadingView.alpha = 0.5;
    [self.view addSubview:_loadingView];
}

//開始loading動畫
-(void)startLoadingView{
    [_loadingView startAnimating];
}
//結束loading動畫
-(void)stopLoadingView{
    [_loadingView stopAnimating];
    
}


#pragma mark basic setting
//設定透明與左按鈕
-(void)setNavigationBar{
    //Navigation Bar 透明.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//颜色
    //[[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0.1];//透明度
    
}
-(void)addNotifiCation{
    //輸入金額時觸發其他cell更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell:) name:@"reloadCell" object:nil];
    //鍵盤出現與消失時自動觸發的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillClose) name:@"UIKeyboardWillHideNotification" object:nil];
    //增加國家時添加cell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCell:) name:@"addCell" object:nil];
    //選擇歷史數據按鈕的期間後，更新按鈕顯示日期
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewOptionHeader:) name:@"renewOptionHeader" object:nil];
    //所有外幣歷史數據完成時回穿的通知，主要是要關閉loading動畫
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCollectionView) name:@"completeLoadYhooHistoricalData" object:nil];
    //讀取完即時匯率後刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:@"completeLoadYahooFavorListRate" object:nil];

}

#pragma mark Notification's selector
-(void)reloadTableView{
//    [self.talbeView reloadData];
}

-(void)reloadCell:(NSNotification*)notification{
    //    NSLog(@"Reload Celling");
    
    NSIndexPath *indexName = [notification.userInfo objectForKey:@"index"];
    CustomTableViewCell *cell = notification.userInfo[@"cell"];
    
    [_yahooCurrencyRateLoader loadYahooCurrency];
    
    self.userKeyIn_Arr = [self getUserKeyIn_Arr];
    self.favorListRate_Dic =[self getFavoritListRate_Dic];
    cellVC = [self.talbeView cellForRowAtIndexPath:indexName];
    
    NSMutableArray *indexPathes = [NSMutableArray array];
    NSIndexPath *indexPath = [self.talbeView indexPathForCell:cell];
    
    
    [self.talbeView.indexPathsForVisibleRows enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [obj compare:indexPath] != NSOrderedSame ){
            [indexPathes addObject:obj];
        }
    }];
    
    [self.talbeView reloadRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone ];
    
    // [cellVC.cell_currencyUserKeyIn  becomeFirstResponder];
}

-(void)keyboardWillShow{
    //    NSLog(@"keyboard will show");
    
    CGAffineTransform rotation = CGAffineTransformScale(self.collectionView.transform, 1, 0.001);
    [UIView animateWithDuration:1.0 animations:^{
        [self.collectionView setCenter:CGPointMake(self.navigationController.navigationBar.bounds.size.width/2,self.navigationController.navigationBar.bounds.size.height+20)];
        self.collectionView.transform= rotation ;
        
        [self.talbeView setFrame:CGRectMake(self.collectionView.frame.origin.x,self.collectionView.frame.origin.y , self.talbeView.frame.size.width, self.talbeView.frame.size.height)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.5 animations:^{
             self.collectionView.alpha = 0;
         }];
     }];
    
}

-(void)keyboardWillClose{
    //    NSLog(@"keyboard will close");
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.talbeView setFrame:self.tableViewFrameDefault];
        [self.collectionView setCenter:self.collectionViewCenterDefault];
        self.collectionView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.collectionView.alpha = 1;
        }];
    }];
}

-(void)addCell:(NSNotification*)notification{
    self.favorListName_Arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favorListName_Arr"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        NSArray *countryNameArr = [[NSArray alloc] initWithObjects:notification.userInfo[@"addCountryName"], nil];
        
        [self.yahooCurrencyRateLoader loadYahooCurrency];
        [self.yahooCurrencyRateLoader loadYahooHistoricalDataNew:countryNameArr keyInCountry:nil];
        
        self.userKeyIn_Arr = [self getUserKeyIn_Arr];
        self.favorListRate_Dic = [self getFavoritListRate_Dic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.favorListName_Arr.count-1 inSection:0];
            [self.talbeView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
            
        });
        
        
    });
    
}

//更新天數option按鈕數字
-(void)renewOptionHeader:(NSNotification*)header{
    /*每個cell天數不同時使用
    NSString *row = header.userInfo[@"row"];
    _collectionOptionTitleDict[row] = header.userInfo[@"header"];
     */

    [self startLoadingView];
    
    _optionHeaderStr = header.userInfo[@"header"];

    NSArray *countryNameArr = [[NSArray alloc] initWithArray:self.favorListName_Arr];
    [_yahooCurrencyRateLoader loadYahooHistoricalDataNew:countryNameArr keyInCountry:nil];

    [self.collectionView reloadData];

}

-(void)reloadCollectionView{
    [self.collectionView reloadData];
    if (_loadingView.animating == TRUE) {
        [_loadingView stopAnimating];
    }
}


#pragma mark Get UserDefault
//getFavorListName_Arr 使用者的最愛清單
-(NSMutableArray*)getUserFavorListName_Arr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorListName_Arr = [NSMutableArray new];
    favorListName_Arr = [[defaults objectForKey:@"favorListName_Arr"] mutableCopy];
    
    if (favorListName_Arr) {
        //        NSLog(@"favorListName_Arr loading from saved is  %@",favorListName_Arr);
        
    }else{
        
        favorListName_Arr =[@[@"USD",@"TWD",@"JPY",@"HKD",@"CNY",@"AUD",@"EUR",@"KRW"]mutableCopy];
        //        NSLog(@"favorListName_Arr new created is   %@",favorListName_Arr);
        
        [defaults setObject:favorListName_Arr forKey:@"favorListName_Arr"];
        [defaults synchronize];
    }
    
    return favorListName_Arr;
}

//get UserKeyIn_Arr 紀錄使用者最後keyIn的基準幣值
-(NSArray*)getUserKeyIn_Arr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *userKeyIn_Arr = [NSArray new];
    userKeyIn_Arr = [defaults objectForKey:@"userKeyIn_Arr"];
    
    if (userKeyIn_Arr) {
        //        NSLog(@"userKeyIn_Arr loading from saved is  %@",userKeyIn_Arr);
        
    }else{
        
        userKeyIn_Arr =@[@"USD",@"1"];
        [defaults setObject:userKeyIn_Arr forKey:@"userKeyIn_Arr"];
        NSLog(@"userKeyIn_Arr new created is   %@",userKeyIn_Arr);
        [defaults synchronize];
    }
    return userKeyIn_Arr;
}

//get favorListRate_Dic
-(NSMutableDictionary*)getFavoritListRate_Dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorListRate_Dic = [NSMutableDictionary new];
    favorListRate_Dic = [defaults objectForKey:@"favorListRate_Dic"];
    [defaults synchronize];
    return favorListRate_Dic;
    
}

//set rangeForURL_str
-(void)setRangeForURL_str{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"7d" forKey:@"rangeForURL_str"];
    [defaults synchronize];
}

//get optionHeaderStr
-(NSString*)getOptionHeaderStr{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *rangeForURL_str = [NSString new];
    rangeForURL_str = [defaults objectForKey:@"rangeForURL_str"];
    
    __block NSString *optionHeaderStr = [NSString new];
    NSDictionary *dayToRange_Dic =[NSDictionary new];
    dayToRange_Dic = @{@"7天":@"7d",@"1月":@"1mo",@"6月":@"6mo",@"1年":@"1y"};
    
    [dayToRange_Dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:rangeForURL_str]) {
            optionHeaderStr = key;
        }
    }];
    
    return optionHeaderStr;
}

#pragma mark tableView dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.favorListName_Arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //從最愛清單中撈出國名
    NSArray *countryList = [[NSArray alloc] initWithArray:self.favorListName_Arr];
    NSArray *userKeyInfo = [[NSArray alloc] initWithArray:self.userKeyIn_Arr];
    
    //用國名配置國旗圖
    NSString *countryName = countryList[indexPath.row];
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png",countryName ];
    
    //用國名撈出幣值名稱
    NSString *currencyName = [self.currencyList_Dic objectForKey:countryName];
    
    cell.cell_countryName.text = countryName;
    cell.cell_countryFlag.image =[UIImage imageNamed:imageName];
    cell.currencyName.text = currencyName;
    
    //取出使用者最後點擊的幣與輸入值去轉產生其他幣的相對值
    cell.cell_userKeyInfo_arr = [userKeyInfo mutableCopy];
    self.favorListRate_Dic = [self getFavoritListRate_Dic];
    NSString *setPrice = userKeyInfo[1];
    NSString *userRate = [self.favorListRate_Dic objectForKey:countryName];
    
    
    [cell showUserFavorList_price:setPrice rate:userRate];
    
    cell.indexName =indexPath;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedCell  = [tableView cellForRowAtIndexPath:indexPath];
    //取消鍵盤
    if ([_selectedCell.cell_currencyUserKeyIn isFirstResponder]) {
        
        [_selectedCell.cell_currencyUserKeyIn resignFirstResponder];
        
    }else{
        //將歷史匯率移到所點選的國家
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
        //[cellVC2.cell_currencyUserKeyIn becomeFirstResponder];
    }
    
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableDictionary *historicalRate_Dic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"historicalRate_Dic"] mutableCopy];
        [historicalRate_Dic removeObjectForKey:self.favorListName_Arr[indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject:historicalRate_Dic forKey:@"historicalRate_Dic"];
        
        [self.favorListName_Arr removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.favorListName_Arr forKey:@"favorListName_Arr"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        [_yahooCurrencyRateLoader loadYahooHistoricalDataNew:self.favorListName_Arr keyInCountry:nil];
    }
    
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // Note* note = [notes objectAtIndex:sourceIndexPath.row];
    //Note* note = notes[sourceIndexPath.row];
    
    NSString *move = self.favorListName_Arr[sourceIndexPath.row];
    [self.favorListName_Arr removeObjectAtIndex:sourceIndexPath.row];
    [self.favorListName_Arr insertObject:move atIndex:destinationIndexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:self.favorListName_Arr forKey:@"favorListName_Arr"];
    [self.collectionView reloadData];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.talbeView setEditing:editing animated:animated];
    
}

#pragma mark collectionView dataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.favorListName_Arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //產生自訂的MyCollectionViewCell
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //從userDefault中取出最愛的貨幣清單
    NSArray *countryList = [[NSUserDefaults standardUserDefaults]objectForKey:@"favorListName_Arr"];
    NSString *countryName = countryList[indexPath.row];
    
    //標示圖表的貨幣名稱
    [cell.countryName_label setTextColor:[UIColor whiteColor]];
    if ([countryName isEqualToString:@"USD"]) {
        NSString * nameAddTWD = [NSString stringWithFormat:@"%@ / TWD",countryName];
        cell.countryName_label.text =nameAddTWD;
    }else{
        NSString * nameAddUSD = [NSString stringWithFormat:@"%@ / USD",countryName];
        cell.countryName_label.text =nameAddUSD;
    }
    
    //顯示圖表的貨幣國旗圖示
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@.png",countryName ];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.flagForLabel.image = image ;
    cell.countryNameStr = countryName;
    
    /*
     NSArray *userKeyIn_Arr = [self getUserKeyIn_Arr];
     NSString *userKeyInCountry_Str = userKeyIn_Arr[0];
     */
    
    //處理天數選項的顯示
    cell.optioneTableViewController.row = indexPath.row;
    
    /*每個content的optionHeader不同時使用
    if (_collectionOptionTitleDict[@(indexPath.row)]) {
        
        [cell.optioneTableViewController updateOptionHeader:_collectionOptionTitleDict[@(indexPath.row)]];
    }else{
        [cell.optioneTableViewController updateOptionHeader:@"1天"];
    }
     */
    if (_optionHeaderStr) {
        [cell.optioneTableViewController updateOptionHeader:_optionHeaderStr];
    }else{
        [cell.optioneTableViewController updateOptionHeader:@"7天"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [cell.optionTableView reloadData];
        [cell setLineChartData];
        [cell updateLineChartData];
    });
    
    
    return cell;
}

-(UIImage *)creatCollectionCellBackgroundGradientImageView {
    
    //使用RGB顏色模型
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //漸層中所包含的關鍵顏色 RGBA
    CGFloat components[] = {0.96, 0.31, 0.0, 0.55,
        0.96, 0.31, 0.0, 0.7,
        0.96, 0.31, 0.0, 0.85,
        0.96, 0.31, 0.0, 1.0};
    //關鍵顏色所出現的位置
    CGFloat locations[] = {0.0, 0.33, 0.55, 1.0};
    //關鍵顏色的個數
    size_t count = 4;
    //製作漸層顏色模型
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, components, locations, count);
    CGColorSpaceRelease(rgb);
    
    
    //製作ImageView
    UIImage *backgroundGradientView = [UIImage new];
//    backgroundGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.collectionView.frame.size.width, self.collectionView.frame.size.height)];
    
    
    //開始繪圖
//    UIGraphicsBeginImageContext(backgroundGradientView.frame.size);
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIGraphicsBeginImageContext(cell.contentView.frame.size);
    //指定畫布
    CGContextRef context = UIGraphicsGetCurrentContext();
    //繪製漸層線條並儲存畫布
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, self.collectionView.frame.size.height), 0);
    CGContextSaveGState(context);
    //將畫布指定給ImageView
    backgroundGradientView = UIGraphicsGetImageFromCurrentImageContext();
    //結束繪圖
    UIGraphicsEndImageContext();
    //設定圓角
//    backgroundGradientView.layer.masksToBounds = YES ;
//    backgroundGradientView.layer.cornerRadius = 15;
    
    return backgroundGradientView;
    
}


- (IBAction)refreshBtn:(id)sender {
    [_yahooCurrencyRateLoader loadYahooCurrency];
    [self.talbeView reloadData];
    
    [self startLoadingView];
    [_yahooCurrencyRateLoader loadYahooHistoricalDataNew:self.favorListName_Arr keyInCountry:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //如果在鍵盤打開的情況之下，要先關閉鍵盤再跳到新增選單
    if ([segue.identifier isEqualToString:@"addListView"]) {
        [self.view endEditing:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
