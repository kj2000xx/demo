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
    //NSArray *countryFlagStr;
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
    NSLog(@" range location is  %lu\n  range length  is %lu\n",(unsigned long)range.location,(unsigned long)range.length);
    //NSInteger strLength = textField.text.length - range.length + string.length;
    //return (strLength <= 13);
        NSString *cleanCentString = [[textField.text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSInteger centValue = [cleanCentString intValue];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber *myNumber = [f numberFromString:cleanCentString];
        NSNumber *result;
        
        if([textField.text length] < 16){
            if (string.length > 0)
            {
                centValue = centValue * 10 + [string intValue];
                double intermediate = [myNumber doubleValue] * 10 +  [[f numberFromString:string] doubleValue];
                result = [[NSNumber alloc] initWithDouble:intermediate];
            }
            else
            {
                centValue = centValue / 10;
                double intermediate = [myNumber doubleValue]/10;
                result = [[NSNumber alloc] initWithDouble:intermediate];
            }
            
            myNumber = result;
            //NSLog(@"%ld ++++ %@", (long)centValue, myNumber);
            NSNumber *formatedValue;
            formatedValue = [[NSNumber alloc] initWithDouble:[myNumber doubleValue]/ 100.0f];
            NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
            [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            //textField.text = [_currencyFormatter stringFromNumber:formatedValue];
            NSString * price = [[_currencyFormatter stringFromNumber:formatedValue] substringFromIndex:1];
            textField.text = price ;
            
           // NSString *setPrice =[_currencyFormatter stringFromNumber:formatedValue];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //NSLog(@"VC.userFavorList_dic   is  %@",VC.userFavorList_dic);
            //NSMutableArray *userKeyInfo = [[VC.userFavorList_dic objectForKey:@"cellKeyInInfo"] mutableCopy];
            
            NSNumberFormatter *decimalFormatter = [NSNumberFormatter new];
            [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [decimalFormatter setMaximumFractionDigits:2];
            [decimalFormatter setUsesGroupingSeparator:NO];
            self.cell_userKeyInfo_arr[0]= self.cell_countryName.text;
            self.cell_userKeyInfo_arr[1] = [decimalFormatter stringFromNumber:formatedValue];
            
            [defaults setObject:_cell_userKeyInfo_arr forKey:@"userKeyIn_Arr"];
            NSLog(@"cell_keyInfo_arr  is    %@",_cell_userKeyInfo_arr);

            [defaults synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCell" object:nil userInfo:@{@"index":self.indexName,@"cell":self}];

                       return NO;
            
        }
        else{
            
//            NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
//            [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyPluralStyle];
//            textField.text = [_currencyFormatter stringFromNumber:00];
//            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Deposit Amount Limit"
//                                                           message: @"You've exceeded the deposit amount limit. Kindly re-input amount"
//                                                          delegate: self
//                                                 cancelButtonTitle:@"Cancel"
//                                                 otherButtonTitles:@"OK",nil];
//            
           // [alert show];
            if(string.length > 0){
                return NO;
            }else{
            return YES;
            }
        }

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
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *currencyPrice  =[formatter stringFromNumber:[NSNumber numberWithFloat:keyValue*changeRate]];
    
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
