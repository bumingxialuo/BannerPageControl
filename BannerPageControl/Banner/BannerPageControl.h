//
//  BannerPageControl.h
//  Thor
//
//  Created by 不明下落 on 2019/7/11.
//  Copyright © 2019 erongdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^tapViewSelectAction)(NSInteger index);

@interface BannerPageControl : UIView
/**
 圆点个数
 */
@property(nonatomic, assign) NSInteger pageCount;

/**
 当前选中圆点
 */
@property(nonatomic, assign) NSInteger currentPage;

/**
 点击视图切换圆点动作
 */
@property(nonatomic, copy) tapViewSelectAction selectAction;

@end

NS_ASSUME_NONNULL_END
