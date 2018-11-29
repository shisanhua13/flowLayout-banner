//
//  CardView.m
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/27.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "CardView.h"
#import "PageCardFlowLayout.h"
#import "PageCardCell.h"
#define MaxSections 4
@interface CardView ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,PageCardFlowLayoutDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic,strong) PageCardFlowLayout *layout;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation CardView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    [self addCollectionView];
}

- (void)addCollectionView
{
    //避免UINavigation对UIScrollView产生的便宜问题
    [self addSubview:[UIView new]];
    
    PageCardFlowLayout *flowLayout = [[PageCardFlowLayout alloc] init];
    flowLayout.delegate = self;
    self.layout = flowLayout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kPageCardHeight + 20) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[PageCardCell class] forCellWithReuseIdentifier:@"PageCardCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    collectionView.backgroundColor = [UIColor orangeColor];
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(collectionView.frame), collectionView.frame.size.width, 20)];
    pageControl.backgroundColor = [UIColor blackColor];
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    pageControl.pageIndicatorTintColor = [UIColor redColor];

}
- (void)scrollToItemIndexPath:(NSInteger)indexPath andSection:(NSInteger)section withAnimated:(BOOL)animated
{
    // 1、根据NSIndexPath，获取布局样式
    UICollectionViewLayoutAttributes *attribute = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath inSection:section]];
    // 2、滚动到attribute的indexPath
    [self.collectionView scrollToItemAtIndexPath:attribute.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    // 3、记录collectionview的偏移量
    self.layout.previousOffsetX = (indexPath + section * self.items.count) * (kPageCardWidth +kLineSpace);
}
#pragma mark CollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"PageCardCell";
    PageCardCell *card = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    card.item = _items[indexPath.row];
    card.backgroundColor = [UIColor yellowColor];
    return card;
}
#pragma mark UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat collectionInset = self.collectionView.bounds.size.width/2.0f - kPageCardWidth/2.0f;
    if (section == 0) {
        return UIEdgeInsetsMake(0, collectionInset, 0, 0);
    } else if (section == (MaxSections - 1)) {
        return UIEdgeInsetsMake(0, 0, 0, collectionInset);
    } else {
        return UIEdgeInsetsMake(0, kLineSpace, 0, 0);
    }
}
#pragma mark PageCardFlowLayoutDelegate
-(void)flowLayoutScrollToPageIndex:(NSInteger)index
{
    NSLog(@"共%ld页", index);
    NSInteger count = self.items.count;
    NSInteger section = index/count;
    NSInteger row = (long)index % count;
    NSLog(@"当前滑动到的是第%ld组第%ld页",section,row);
    // 1、设置当前的页数
    self.pageControl.currentPage = row;
    // 2、当滑动到了边缘组的时候，重新回到中间的组
    if (section == 0) {
        if (row <=(count -1)) {
            [self scrollToItemIndexPath:0 andSection:(MaxSections/2 - 1) withAnimated:NO];
        }
    } else if (section ==(MaxSections - 1)) {
        if (row >= 0) {
            [self scrollToItemIndexPath:0 andSection:(MaxSections/2 - 1) withAnimated:NO];
        }
    }
}
#pragma mark - 定时器自动翻页(改变偏移量，根据偏移量来计算当前页数)
- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_time target:self selector:@selector(updateTheScrollView:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
// 定时器滚动
- (void)updateTheScrollView:(NSTimer *)timer
{
    //1、改变collectionView偏移量
    CGPoint offSet = self.collectionView.contentOffset;
    offSet.x = offSet.x + (kPageCardWidth +kLineSpace);
    [self.collectionView setContentOffset:offSet animated:YES];
    //2、记录collectionview的偏移量
    self.layout.previousOffsetX = offSet.x;
    //3、改变当前点点
    NSInteger index = offSet.x/(kPageCardWidth +kLineSpace);
    [self flowLayoutScrollToPageIndex:index];
}
#pragma mark - 解决手动滑动 和 定时器滑动 之间的冲突
//手指开始滑动时才执行
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
//手指离开时才执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

/**
 * 自动轮播时间
 */
- (void)setTime:(NSInteger)time
{
    //    NSLog(@"是否先执行ta");
    _time = time;
    [self stopTimer];
    [self startTimer];
}
/**
 * 轮播数组
 */
-(void)setItems:(NSArray *)items
{
    _items = items;
    self.pageControl.numberOfPages = items.count;
    [self scrollToItemIndexPath:0 andSection:(MaxSections/2 - 1) withAnimated:YES];
    self.time = 6;
}
@end
