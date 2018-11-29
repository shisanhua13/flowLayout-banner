//
//  PageCardFlowLayout.h
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/26.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPageCardWidth 160
#define kPageCardHeight 160
//卡片间距
#define kLineSpace 10

@protocol PageCardFlowLayoutDelegate <NSObject>
-(void)flowLayoutScrollToPageIndex:(NSInteger)index;
@end
@interface PageCardFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<PageCardFlowLayoutDelegate> delegate;
/** 记录collectionView滚动的偏移量**/
@property (nonatomic, assign) CGFloat previousOffsetX;
@end

