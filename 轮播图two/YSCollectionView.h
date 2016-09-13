//
//  YSCollectionView.h
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class YSCollectionView;

@protocol YSCollectionViewDelegate <NSObject>

- (void)YSCollectionView :(UICollectionView *)collectionView WithCurrentPage:(NSInteger)currentPage;

@end

@interface YSCollectionView : UICollectionView

- (instancetype)initWithUrls:(NSArray <NSString *> *)urls;
@property(nonatomic,weak)id <YSCollectionViewDelegate> pageDelegate;
@end
