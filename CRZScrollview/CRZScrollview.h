//
//  CRZScrollview.h
//  TestDemo
//
//  Created by ChenQing on 2017/11/14.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRZScrollview;

@protocol CRZScrollviewDelegate <NSObject>

-(void)CRZScrollview:(CRZScrollview *)scrollview
            selected:(NSInteger)index;

@end

@interface CRZScrollview : UIView

@property (nonatomic,weak) id<CRZScrollviewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame
                   ImageUrls:(NSArray *)imageUrls
                IntervalTime:(CGFloat)intervalTime;

@end
