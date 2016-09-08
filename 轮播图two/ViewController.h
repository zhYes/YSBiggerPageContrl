//
//  ViewController.h
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDeleage <NSObject>

- (void)bigBig :(CGFloat)offset;

@end

@interface ViewController : UIViewController

@property(nonatomic,weak)id <ViewControllerDeleage> delegate;

@end

