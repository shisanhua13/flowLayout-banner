//
//  PageCardCell.m
//  卡片式二
//
//  Created by ZILIANG HA on 2018/11/27.
//  Copyright © 2018 Wang Na. All rights reserved.
//

#import "PageCardCell.h"
@interface PageCardCell ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *textLabel;
@end
@implementation PageCardCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}
- (void)buildUI
{
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelHeight = self.bounds.size.height * 0.20f;
    CGFloat imageViewHeight = self.bounds.size.height - labelHeight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, imageViewHeight)];
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = true;
    [self addSubview:imageView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageViewHeight, self.bounds.size.width, labelHeight)];
    self.textLabel = textLabel;
    textLabel.textColor = [UIColor grayColor];
    textLabel.font = [UIFont systemFontOfSize:22];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:textLabel];
}
-(void)setItem:(XLCardItem *)item {
    _imageView.image = [UIImage imageNamed:item.imageName];
    _textLabel.text = item.title;
}
@end



@implementation XLCardItem

@end
