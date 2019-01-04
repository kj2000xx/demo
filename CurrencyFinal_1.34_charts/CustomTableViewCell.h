//
//  CustomTableViewCell.h
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/4.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cell_countryFlag;
@property (weak, nonatomic) IBOutlet UILabel *cell_countryName;
@property (weak, nonatomic) IBOutlet UILabel *cell_currencyPrice;
@property (weak, nonatomic) IBOutlet UITextField *cell_currencyUserKeyIn;

@property(strong, nonatomic) NSArray *country_arry;
@property (weak, nonatomic) IBOutlet UILabel *currencyName;

/*
@property NSMutableDictionary *userFavorList_dic;
@property NSMutableDictionary * userRate_dic;
*/
@property NSIndexPath *indexName;

@property NSMutableArray *cell_userKeyInfo_arr;
-(void)showUserFavorList_price:(NSString*)userKeyValue rate:(NSString*)rate;
@end
