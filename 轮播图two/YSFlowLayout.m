//
//  YSFlowLayout.m
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import "YSFlowLayout.h"

@interface YSFlowLayout ()

@end

@implementation YSFlowLayout

- (void)prepareLayout {
//    NSLog(@"%@",self.collectionView);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.itemSize = self.collectionView.bounds.size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsVerticalScrollIndicator = 0;
    self.collectionView.showsHorizontalScrollIndicator = 0;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bigBig:) name:@"zys" object:nil];
}


- (void)bigBig:(NSNotification *)info{
    NSDictionary * dic = info.userInfo;
    NSString * offset = dic[@"offset"];
    CGFloat off = [offset integerValue];
    CGSize size = self.itemSize;
    size.height = 200 - off ;
    self.itemSize = size;
//    NSLog(@"%f",self.itemSize.height);
}

@end
