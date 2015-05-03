//
//  ZWPViewController.m
//  无限滚动
//
//  Created by Wei Peng Zhuang on 5/1/15.
//  Copyright (c) 2015 WeiPengZhuang. All rights reserved.
//

#import "ZWPViewController.h"
#import "ZWPNewsCell.h"
#import "MJExtension.h"
#import "ZWPNews.h"


#define ZWPMaxSection 50
#define WPCellIdentifier @"news"

@interface ZWPViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *newes;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic , strong) NSTimer *timer;


@end

@implementation ZWPViewController

- (NSArray *)newes
{
    if (!_newes) {
        self.newes = [ZWPNews objectArrayWithFilename:@"newses.plist"];
        self.pageControl.numberOfPages = self.newes.count;
    }
    return _newes;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZWPNewsCell" bundle:nil] forCellWithReuseIdentifier:WPCellIdentifier];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:ZWPMaxSection / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    
    //添加定时器
    [self addTimer];
    
    
   
}
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)removeTimer
{
 //停止定时器
    [self.timer invalidate];
    
    self.timer = nil;
}
- (NSIndexPath *)resetIndexpath
{
    //当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    //马上显示回最中间那组的数据
    NSIndexPath *currentIndexPathRest = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:ZWPMaxSection / 2] ;
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathRest atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return currentIndexPathRest;
}

- (void)nextPage
{
    
    NSIndexPath *currentIndexPathRest = [self resetIndexpath];
    
    //计算出下一个需要展示的位置
    NSInteger nextItem = currentIndexPathRest.item  +1;
    NSInteger nextSection =  currentIndexPathRest.section;
    
    if (nextItem == self.newes.count) {
        nextItem = 0;
        nextSection ++ ;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    //通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newes.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ZWPMaxSection;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = WPCellIdentifier;
    ZWPNewsCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.news = self.newes[indexPath.item];
       
    return cell;
    
    
}

#pragma mark -UICollectionViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newes.count;
    self.pageControl.currentPage = page;

}
// - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self resetIndexpath];
//}
@end
