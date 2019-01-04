//
//  AddlistTableViewCell.m
//  Currency
//
//  Created by Shane on 2016/4/27.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "AddlistTableViewCell.h"

@interface AddlistTableViewCell ()

@end

@implementation AddlistTableViewCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.flag_imageView.layer.masksToBounds =YES;
    self.flag_imageView.layer.cornerRadius = self.flag_imageView.frame.size.width / 2;
    
}

@end
