//
//  ZWPNewsCell.m
//  无限滚动
//
//  Created by Wei Peng Zhuang on 5/1/15.
//  Copyright (c) 2015 WeiPengZhuang. All rights reserved.
//

#import "ZWPNewsCell.h"
#import "ZWPNews.h"

@interface ZWPNewsCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation ZWPNewsCell

- (void)setNews:(ZWPNews *)news
{
    _news = news;
    self.imageView.image = [UIImage imageNamed: news.icon];
    
    
    self.titleView.text = [NSString stringWithFormat:@" %@",news.title];
    
}


@end
