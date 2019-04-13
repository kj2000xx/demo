//
//  OptionTableViewController.h
//  CurrencyFinal_1.34_charts
//
//  Created by Shane on 2018/7/25.
//  Copyright © 2018年 Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionTableViewController : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) BOOL isOpen;
@property(strong,nonatomic) NSArray *optionItem;
@property(strong,nonatomic) NSString *optionHeader;
@property(nonatomic) CGRect tableFrame;

@property(nonatomic) NSInteger row;

-(void)updateOptionHeader:(NSString *)newString;
@end
