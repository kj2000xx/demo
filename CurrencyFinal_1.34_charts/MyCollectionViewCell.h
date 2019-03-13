//
//  MyCollectionViewCell.h
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/6.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewController.h"
#import "CurrencyFinal_1.34_charts-Bridging-Header.h"

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSString *countryName_cell;
@property(nonatomic) UILabel *countryName_label;
@property(nonatomic) UIImageView *flagForLabel;
@property(nonatomic) NSString *countryNameStr;

//@property(nonatomic) LineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet LineChartView *lineChartView;
@property(nonatomic) LineChartData *lineChartData;

@property(nonatomic) NSString *tableTitleHeader;
@property(nonatomic) OptionTableViewController *optioneTableViewController;
@property (weak, nonatomic) IBOutlet OptionTableViewController *optionTableView;

//歷史數據view的方法
-(void)setLineChartData;//輸入歷史數據資料，需要countryName就位
-(void)updateLineChartData;//顯示出數據資料
@end
