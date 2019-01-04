//
//  MyCollectionViewCell.h
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/6.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionTableViewController.h"

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSString *countryName_cell;
@property(nonatomic) UILabel *countryName_label;
@property(nonatomic) UIImageView *flagForLabel;

@property(nonatomic) NSString *tableTitleHeader;
@property(nonatomic) OptionTableViewController *optioneTableViewController;
@property (weak, nonatomic) IBOutlet OptionTableViewController *optionTableView;



@end
