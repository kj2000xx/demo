//
//  MyUICollectionViewFlowLayout.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/7.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "MyUICollectionViewFlowLayout.h"

//    CGFloat ItemHW = 320;
    CGFloat ItemMaigin = 0;


@implementation MyUICollectionViewFlowLayout

-(void)prepareLayout
{
    [super prepareLayout];
    
    //初始化
//    self.estimatedItemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
//    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);//247
    self.itemSize = self.collectionView.bounds.size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = ItemMaigin;
    CGFloat inset = ItemMaigin;
    //CGFloat inset = (self.collectionView.frame.size.width - ItemHW) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);

}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //計算scrollView最後停留的範圍
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //取出範圍內的所有屬性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //起始的x值，也是默認情況下要停下来的x值
    CGFloat startX = proposedContentOffset.x;
    
    //遍歷所有的屬性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat attrsX = CGRectGetMinX(attrs.frame);
        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
        
        if (startX - attrsX  < attrsW/2) {
            adjustOffsetX = -(startX - attrsX+ItemMaigin);
        }else{
            adjustOffsetX = attrsW - (startX - attrsX);
        }
        
        break ;//只循環數組中第一个元素，直接break
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
