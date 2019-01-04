//
//  CustomTextField_NoMenu.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/20.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "CustomTextField_NoMenu.h"

@implementation CustomTextField_NoMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    [UIMenuController sharedMenuController].menuVisible = NO;  //do not display the menu
    //[self resignFirstResponder];                      //do not allow the user to selected anything
    return NO;
}



@end
