//
//  OptionTableViewController.m
//  CurrencyFinal_1.34_charts
//
//  Created by Shane on 2018/7/25.
//  Copyright © 2018年 Shane. All rights reserved.
//

#import "OptionTableViewController.h"

@interface OptionTableViewController ()

@end

@implementation OptionTableViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _isOpen = false;
        _optionHeader = @"7天";
        _optionItem = @[@"7天",@"1月",@"6月",@"1年"];
    }
    return self;
}

-(void)updateOptionHeader:(NSString *)newString{
    if (self) {
        _optionHeader = newString;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 25;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isOpen) {
        return _optionItem.count+1;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFont *textLabelFont = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title" forIndexPath:indexPath];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = textLabelFont;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
//        cell.backgroundColor = [UIColor clearColor];//背景設定為透明色
        cell.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        
        
        cell.textLabel.text = _optionHeader;
        return  cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = textLabelFont;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        
//        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];

        cell.textLabel.text = _optionItem[indexPath.row-1];
        return  cell;
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isOpen == false ) {
        _isOpen = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationAutomatic ];
            [UIView animateWithDuration:0.25 animations:^{
                self->_tableFrame.size.height = tableView.contentSize.height;
                tableView.frame = self->_tableFrame;
            }];
        });
        
    }else{
        _isOpen = false;
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationAutomatic ];
                [UIView animateWithDuration:0.3 animations:^{
                    self->_tableFrame.size.height = tableView.contentSize.height;
                    tableView.frame = self->_tableFrame;
                }];
                
            });
        }else{
            //轉換給url用的range格式
            NSDictionary *dayToRange_Dic =[NSDictionary new];
            dayToRange_Dic = @{@"7天":@"7d",@"1月":@"1mo",@"6月":@"6mo",@"1年":@"1y"};
            //儲存
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dayToRange_Dic[_optionItem[indexPath.row-1]] forKey:@"rangeForURL_str"];
            [defaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.05 animations:^{
                    [tableView reloadData];
                    self->_tableFrame.size.height = tableView.contentSize.height;
                    tableView.frame = self->_tableFrame;
                }];
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"renewOptionHeader" object:nil userInfo:@{@"header":self->_optionItem[indexPath.row-1],@"row":@(self.row)}];
            
        }
        
        
    }
    
}





/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
