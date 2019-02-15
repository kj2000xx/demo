//
//  CustomTableViewCell.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/4.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "ViewController.h"

@implementation CustomTableViewCell{
    ViewController *vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_cell_countryFlag setContentMode:UIViewContentModeScaleAspectFit];
    
    self.cell_currencyUserKeyIn.delegate = self;
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:@"UITextFieldTextDidChangeNotification" object:nil];
}
-(BOOL)becomeFirstResponder{
    return YES;
}

#pragma mark change format for textfield's text input

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //textField顯示用的格式
    NSNumberFormatter *textDecimalStyleFormatter = [NSNumberFormatter new];
    //    [textDecimalStyleFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    textDecimalStyleFormatter.usesGroupingSeparator = YES;
    textDecimalStyleFormatter.groupingSize = 3;
    textDecimalStyleFormatter.maximumFractionDigits = 4;
    textDecimalStyleFormatter.roundingMode = NSNumberFormatterRoundDown;
    
    //NSUserDefaults儲存用得格式
    NSNumberFormatter *userDefaultDecimalFormatter = [NSNumberFormatter new];
    //    [userDefaultDecimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [userDefaultDecimalFormatter setMaximumFractionDigits:4];
    [userDefaultDecimalFormatter setUsesGroupingSeparator:NO];
    
    
    if (range.length == 1) {//輸入刪除時
        NSString *priceString = [self deleteLastCharacter:textField.text];
        
        //清除string內的所有符號才能轉成NSNumber
        //        NSString *cleanCentString = [[priceString componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        
        NSString *cleanCentString = [[priceString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@","]] componentsJoinedByString:@""];
        NSNumber *priceNumber = [textDecimalStyleFormatter numberFromString:cleanCentString];
        priceString = [textDecimalStyleFormatter stringFromNumber:priceNumber];
        
        textField.text = priceString;
        
        self.cell_userKeyInfo_arr[0]= self.cell_countryName.text;
        self.cell_userKeyInfo_arr[1] = [userDefaultDecimalFormatter stringFromNumber:priceNumber];
        [self saveToUserKeyInArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"index":self.indexName,@"cell":self}];
        return NO;
    }
    if ([textField.text length] < 24) {//判斷是否超出長度
        
        if ([string isEqualToString:@"."]) {//檢查有無重複輸入符號.
            if ([textField.text containsString:@"."]) {
                return NO;//重複輸入超過兩個"."不更改結果
            }else{
                
                NSString *textFieldAppendString = textField.text;
                
                //清除string內的所有符號才能轉成NSNumber
                //                NSString *cleanCentString = [[textFieldAppendString componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                NSString *cleanCentString = [[textFieldAppendString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@","]] componentsJoinedByString:@""];
                
                NSNumber *priceNumber = [textDecimalStyleFormatter numberFromString:cleanCentString];
                textFieldAppendString = [textDecimalStyleFormatter stringFromNumber:priceNumber];
                
                textField.text = [textFieldAppendString stringByAppendingString:string];
                
                self.cell_userKeyInfo_arr[0]= self.cell_countryName.text;
                self.cell_userKeyInfo_arr[1] = [userDefaultDecimalFormatter stringFromNumber:priceNumber];
                [self saveToUserKeyInArray];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"index":self.indexName,@"cell":self}];
                
                return NO;
            }
        }
        //輸入的不是"."不需檢查有無重複，直接直接更改字串結果
        NSString *textFieldAppendString = [textField.text stringByAppendingString:string];
        
        //清除string內的所有符號才能轉成NSNumber
        //        NSString *cleanCentString = [[textFieldAppendString componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSString *cleanCentString = [[textFieldAppendString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@","]] componentsJoinedByString:@""];
        
        NSNumber *priceNumber = [textDecimalStyleFormatter numberFromString:cleanCentString];
        NSString *textFieldAppendStringForNoDot = [textDecimalStyleFormatter stringFromNumber:priceNumber];
        
        if ([textFieldAppendString containsString:@"."]) {
            //限制小數點位數最多輸入四位
            NSRange range = [textField.text rangeOfString:@"."];
            NSUInteger dotLocation = range.location;
            NSUInteger textLength = [textField.text length];
            NSUInteger decimalPlace = textLength-(dotLocation+1);
            if (decimalPlace >= 4) {
                return NO;
            }
            
            textField.text = textFieldAppendString;
        }else{
            textField.text = textFieldAppendStringForNoDot;
        }
        
        self.cell_userKeyInfo_arr[0]= self.cell_countryName.text;
        self.cell_userKeyInfo_arr[1] = [userDefaultDecimalFormatter stringFromNumber:priceNumber];
        
        [self saveToUserKeyInArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"index":self.indexName,@"cell":self}];
        return NO;
        
    }else{
        return NO;//輸入字串超過設定的最大長度不更改
    }
}

//刪除最後一個字
-(NSString*) deleteLastCharacter:(NSString*)sourceString
{
    NSString* retString;
    if(0 == [sourceString length])
    {
        retString = sourceString;
        
    }
    else if (1 == [sourceString length])
    {
        //        retString = [sourceString substringToIndex:([sourceString length]-1)];
        retString = @"0";
    }
    else
    {
        retString = [sourceString substringToIndex:([sourceString length]-1)];
    }
    return retString;
}

//將輸入完的字存進UseKeyInArray
-(void)saveToUserKeyInArray{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_cell_userKeyInfo_arr forKey:@"userKeyIn_Arr"];
    [defaults synchronize];
    NSLog(@"cell_keyInfo_arr  is    %@",_cell_userKeyInfo_arr);
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"index":self.indexName}];
    return YES;
}


#pragma mark show the price in textfield
-(void)showUserFavorList_price:(NSString*)userKeyValue rate:(NSString*)rate{
    float keyValue = [userKeyValue floatValue];
    float changeRate = [rate floatValue];
    //NSString *currencyPrice =[NSString stringWithFormat:@"%.2f",keyValue*changeRate];
    
    NSNumberFormatter *formatter =[NSNumberFormatter new];
    [formatter setMaximumFractionDigits:4];
    //    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    formatter.roundingMode = NSNumberFormatterRoundDown;
    
    
    NSString *currencyPrice = [NSString new];
    if (!changeRate) {
        currencyPrice = [NSString stringWithFormat:@"%.4f",keyValue];
        NSNumber *priceNumber = [formatter numberFromString:currencyPrice];
        currencyPrice =[formatter stringFromNumber:priceNumber];
        
    }else{
        currencyPrice = [NSString stringWithFormat:@"%.4f",(keyValue*changeRate)];
        NSNumber *priceNumber = [formatter numberFromString:currencyPrice];
        currencyPrice =[formatter stringFromNumber:priceNumber];
        
    }
    
    
    //self.cell_currencyPrice.text = currencyPrice;
    self.cell_currencyUserKeyIn.text = currencyPrice;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}


/*
 #pragma mark close keyboard
 - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
 if (![self.cell_currencyUserKeyIn isExclusiveTouch]) {
 [self.cell_currencyUserKeyIn resignFirstResponder];
 }
 }
 */



@end
