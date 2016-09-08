//
//  ViewController.m
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import "ViewController.h"
#import "YSCollectionView.h"
#import "HMObjcSugar.h"
#import "objc/runtime.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource,YSCollectionViewDelegate>

@end

NSString * const tableCellId = @"tableCellId";
#define kHeaderHeight 200
#define kPageHeight 20
@implementation ViewController {
    NSArray <NSURL *>           *_urls;
    YSCollectionView            *_collectionView;
    UIView                      *_header;
    UIStatusBarStyle            _statusBarYStyle;
    UIPageControl               *_myPageControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addTableView];
    [self addHeardView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _statusBarYStyle = UIStatusBarStyleLightContent;
}

- (void)addTableView {
    UITableView * table = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellId];
    table.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
}

- (void)addHeardView {
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.hm_width, kHeaderHeight)];
    _header.backgroundColor = [UIColor hm_colorWithHex:0xF8F8F8];
    [self.view addSubview:_header];
    _collectionView = [[YSCollectionView alloc] initWithUrls:_urls];
    _collectionView.pageDelegate = self;
    _collectionView.frame = CGRectMake(0, 0, self.view.hm_width, kHeaderHeight);
    [_header addSubview:_collectionView];
    
    [self addPageControl];
}
- (void)YSCollectionView:(UICollectionView *)collectionView WithCurrentPage:(NSInteger)currentPage {
    _myPageControl.currentPage = currentPage;
}
- (void)addPageControl {
    CGFloat pageW = 20 * _urls.count;
    CGFloat pageH = kPageHeight;
    _myPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((_header.hm_width - pageW) * 0.5, _header.hm_height - pageH, pageW, pageH)];
//    _myPageControl.backgroundColor = [UIColor redColor];
    [_header addSubview:_myPageControl];
    _myPageControl.pageIndicatorTintColor = [UIColor greenColor];
    _myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _myPageControl.numberOfPages = _urls.count;
    
//    [self getUIPageControlProperties];
    [_myPageControl setValue:[UIImage imageNamed:@"pageCurrent.png"] forKey:@"_currentPageImage"];
    [_myPageControl setValue:[UIImage imageNamed:@"pageOther.png"] forKey:@"_pageImage"];
}

- (void)getUIPageControlProperties{
    unsigned int count;
    /**
     1.获取属性列表y
     参数1:获取哪个类的
     参数2:count表示你该类里面有多少个属性
     
     propertyList 它就相当于一个数组
     */
    /**
     class_copyPropertyList 这个方法只能获取类的公有属性
     
     class_copyIvarList 能获取类的所有属性,包括私有属性
     */
    
    Ivar *propertyList = class_copyIvarList([UIPageControl class], &count);
    
    for (int i=0; i<count; i++) {
        //2.取出objc_property_t数组中的property
        Ivar property = propertyList[i];
        
        //3.获取的是C语言的名称
        const char *cPropertyName = ivar_getName(property);
        
        //4.将C语言的字符串转成OC的
        NSString * ocPropertyName = [[NSString alloc] initWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        
        //5.打印结果如下 ,我们重点关心的就是 _pageImage , _currentPageImage
        //  我们知道了这两个名字 就可以利用KVC设置我们想要的图片!
        
//        NSLog(@"%@",ocPropertyName);
        /*
         
         2016-09-08 10:57:36.488 轮播图two[71257:3736607] _lastUserInterfaceIdiom
         2016-09-08 10:57:36.489 轮播图two[71257:3736607] _indicators
         2016-09-08 10:57:36.489 轮播图two[71257:3736607] _currentPage
         2016-09-08 10:57:36.490 轮播图two[71257:3736607] _displayedPage
         2016-09-08 10:57:36.490 轮播图two[71257:3736607] _pageControlFlags
         2016-09-08 10:57:36.493 轮播图two[71257:3736607] _currentPageImage
         2016-09-08 10:57:36.494 轮播图two[71257:3736607] _pageImage
         2016-09-08 10:57:36.494 轮播图two[71257:3736607] _currentPageImages
         2016-09-08 10:57:36.495 轮播图two[71257:3736607] _pageImages
         2016-09-08 10:57:36.495 轮播图two[71257:3736607] _backgroundVisualEffectView
         2016-09-08 10:57:36.496 轮播图two[71257:3736607] _currentPageIndicatorTintColor
         2016-09-08 10:57:36.496 轮播图two[71257:3736607] _pageIndicatorTintColor
         2016-09-08 10:57:36.496 轮播图two[71257:3736607] _legibilitySettings
         2016-09-08 10:57:36.497 轮播图two[71257:3736607] _numberOfPages
         */
    }
    
    //5.C语言中,用完copy,create的东西之后,最好释放
    free(propertyList);
}

- (void)loadData {
    NSMutableArray * temp = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        NSString * fileName = [NSString stringWithFormat:@"%zd.jpg",i];
        NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        [temp addObject:url];
    }
    _urls = temp.copy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + kHeaderHeight;
//    NSLog(@"%f",offset);
    if (offset < 0) {
        NSDictionary *dic = @{
                              @"offset" : [NSString stringWithFormat:@"%f",offset]
                              };
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zys" object:nil userInfo:dic];
        _header.hm_height = kHeaderHeight;
        _header.hm_y = 0;
        _header.hm_height = kHeaderHeight - offset;
        _collectionView.alpha = 1;
    } else {
        
        _header.hm_y = 0;
        CGFloat minOffset = kHeaderHeight - 64;
        _header.hm_y = minOffset > offset ? - offset : - minOffset;
        
        CGFloat progress = 1 - (offset / minOffset);
        _collectionView.alpha = progress;
        _statusBarYStyle = progress < 0.4 ? UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        _myPageControl.alpha = progress;
    }
    _collectionView.hm_height = _header.hm_height;
    _myPageControl.hm_y = _header.hm_height - kPageHeight;
}




- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarYStyle;
}


// zhu yi  yi chu  tong  zhi ..  !移!除!
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tingzhi" object:nil userInfo:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jixu" object:nil userInfo:nil];
}

@end
