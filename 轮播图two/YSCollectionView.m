//
//  YSCollectionView.m
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import "YSCollectionView.h"
#import "YSFlowLayout.h"
#import "YSCollectionViewCell.h"
#import "HMObjcSugar.h"

@interface YSCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end


NSString * const YSCollectionViewCellId = @"YSCollectionViewCellId";

@implementation YSCollectionView {
    NSArray <NSURL *>   *_urls;
    UIScrollView        *_scrollV;
    NSTimer             *_timer;
}

- (instancetype)initWithUrls:(NSArray <NSURL *> *)urls
{
    self = [super initWithFrame:CGRectZero collectionViewLayout:[[YSFlowLayout alloc] init]];
    if (self) {
        _urls = urls;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[YSCollectionViewCell class] forCellWithReuseIdentifier:YSCollectionViewCellId];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath * path = [NSIndexPath indexPathForItem:_urls.count * 10 inSection:0];
            [self scrollToItemAtIndexPath:path atScrollPosition:0 animated:NO];
        });
        [self addTimer];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tingzhi) name:@"tingzhi" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jixu) name:@"jixu" object:nil];
    }
    return self;
}

- (void)tingzhi {
    [_timer invalidate];
    _timer = nil;
}

- (void)jixu {
    [self addTimer];
}

- (void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage {
    NSUInteger page = _scrollV.contentOffset.x / self.hm_width + 1;
    NSLog(@"%zd",page);
    NSIndexPath * path = [NSIndexPath indexPathForItem:page  inSection:0];
    [self scrollToItemAtIndexPath:path atScrollPosition:0 animated:YES];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _urls.count * 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YSCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:YSCollectionViewCellId forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor hm_randomColor];
    cell.url = _urls[indexPath.item % _urls.count];
//    NSInteger currentP = [indexPath.item % _urls.count];
    if ([self.pageDelegate respondsToSelector:@selector(YSCollectionView:WithCurrentPage:)]) {
        [self.pageDelegate YSCollectionView:collectionView WithCurrentPage:(indexPath.item % _urls.count)];
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger pageOffset = scrollView.contentOffset.x / self.hm_width;
    if (pageOffset == 0) {
        NSLog(@"0");
        scrollView.contentOffset = CGPointMake(_urls.count * self.hm_width, 0);
    }
    if (pageOffset == [self numberOfItemsInSection:0] - 1) {
        NSLog(@"5");
        scrollView.contentOffset = CGPointMake(_urls.count * self.hm_width - self.hm_width, 0);
    }
    _scrollV = scrollView;
}

@end
