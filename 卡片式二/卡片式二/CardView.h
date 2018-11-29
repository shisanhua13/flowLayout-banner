//
//  CardView.h
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/27.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CardView : UIView
/**
 设置数据源
 */
@property (nonatomic, strong) NSArray *items;
/* 自动轮播时间间隔*/
@property (nonatomic, assign) NSInteger time;
@end

