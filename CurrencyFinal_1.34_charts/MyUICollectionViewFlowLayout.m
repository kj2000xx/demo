//
//  MyUICollectionViewFlowLayout.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/7.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "MyUICollectionViewFlowLayout.h"

    CGFloat ItemHW = 320;
    CGFloat ItemMaigin = 0;


@implementation MyUICollectionViewFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化
    self.itemSize = CGSizeMake(370, 247);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ItemMaigin;
    CGFloat inset = ItemMaigin;
    //CGFloat inset = (self.collectionView.frame.size.width - ItemHW) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1.计算scrollview最后停留的范围
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //起始的x值，也即默认情况下要停下来的x值
    CGFloat startX = proposedContentOffset.x;
    
    //3.遍历所有的属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat attrsX = CGRectGetMinX(attrs.frame);
        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
        
        if (startX - attrsX  < attrsW/2) {
            adjustOffsetX = -(startX - attrsX+ItemMaigin);
        }else{
            adjustOffsetX = attrsW - (startX - attrsX);
        }
        
        break ;//只循环数组中第一个元素即可，所以直接break了
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
