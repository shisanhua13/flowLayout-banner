//
//  PageCardFlowLayout.m
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/26.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "PageCardFlowLayout.h"
@interface PageCardFlowLayout()
@property (nonatomic,assign) int pageNum;
@end
@implementation PageCardFlowLayout
#pragma mark - 配置方法
//section的左右内边距
-(CGFloat)collectionInset
{
    return self.collectionView.bounds.size.width/2.0f - kPageCardWidth/2.0f;
}

/*
* 预布局方法，所有的布局应该写在这里面
*/
- (void)prepareLayout
{
    [super prepareLayout];
    // 1、设置滑动方向
    // 滑动方向与cell的布局排列有关系
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 2、设置section的内边距
    self.sectionInset = UIEdgeInsetsMake(0, [self collectionInset], 0, [self collectionInset]);
    // 3、设置cell的大小
    self.itemSize = CGSizeMake(kPageCardWidth, kPageCardHeight);
    // 4、设置cell的间距
    self.minimumLineSpacing = kLineSpace;
}
/**
 * 此方法返回当前屏幕正在显示的视图(cell 头尾视图)的布局属性集合
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 1、获取系统生成的布局集合
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    // 备份一份布局集合
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    // 2、屏幕中线
    CGRect collectionViewRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    CGFloat centerX = CGRectGetMidX(collectionViewRect);
    // 3、刷新cell的缩放布局
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        // cell的中心位置和屏幕中心的距离
        CGFloat distance = fabs(attribute.center.x - centerX);
        // cell与屏幕中线的距离(移动的距离) 和 cell宽度的比例
        CGFloat apartScale = distance/self.itemSize.width;
        // 把卡片移动范围固定到[-π/4 π/4]这个范围
        CGFloat scale = 1 - fabs(distance) / (self.itemSize.width *6.0) * fabs(cos(apartScale *M_PI/4));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        attribute.transform = CGAffineTransformMakeScale(scale, scale);
    }];
    return attributes;
}
//是否实时刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}
/**
 * 用于控制滚动的方法
 * 手动滑动collectionview的时候，会触发这个方法
 * proposedContentOffset:collectionview内容视图滚动的偏移量
 
 * 用这个方法，来设置手动滑动时，完成分页滚动
 */

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 分页以1/3处
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        // 重新设置collectionview的内容视图滑动偏移量
        self.previousOffsetX += kPageCardWidth+kLineSpace;
    } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0){
        // 重新设置collectionview的内容视图滑动偏移量
        self.previousOffsetX -= kPageCardWidth+kLineSpace;
    }
    // 重新设置
    proposedContentOffset.x = self.previousOffsetX;
    
    // 获取滑动的cell个数，可以用他来当做当前显示的cell是第一个
    self.pageNum = self.previousOffsetX/(kPageCardWidth+kLineSpace);
    if ([self.delegate respondsToSelector:@selector(flowLayoutScrollToPageIndex:)]) {
        [self.delegate flowLayoutScrollToPageIndex:self.pageNum];
    }
    return proposedContentOffset;
}

@end
