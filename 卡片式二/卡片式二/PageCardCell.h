//
//  PageCardCell.h
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/27.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLCardItem;
@interface PageCardCell : UICollectionViewCell
@property (nonatomic, strong) XLCardItem *item;
@end



@interface XLCardItem : NSObject
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@end
