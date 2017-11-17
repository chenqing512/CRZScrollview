//
//  CRZScrollview.m
//  TestDemo
//
//  Created by ChenQing on 2017/11/14.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "CRZScrollview.h"
#import "UIImageView+WebCache.h"
#import "CRZWeakTarget.h"

@interface CRZScrollview()<UIScrollViewDelegate>

@property (nonatomic,copy) NSArray *imageUrls;
@property (nonatomic,assign) CGFloat intervalTime;

@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UIPageControl *pageControl;


@end

@implementation CRZScrollview

-(instancetype)initWithFrame:(CGRect)frame ImageUrls:(NSArray *)imageUrls IntervalTime:(CGFloat)intervalTime{
    if (self=[super initWithFrame:frame]) {
        self.imageUrls=[NSArray arrayWithArray:imageUrls];
        self.intervalTime=intervalTime;
        self.currentPage=0;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.scrollview];
    [self addSubview:self.pageControl];
    [self setupImageView];
    [self setupTimer];
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-35, 100, 30)];
        _pageControl.numberOfPages=self.imageUrls.count;
        _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    }
    return _pageControl;
}

-(UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollview.contentSize=CGSizeMake(CGRectGetWidth(self.scrollview.frame)*3, CGRectGetHeight(self.scrollview.frame));
        _scrollview.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollview.delegate=self;
        _scrollview.pagingEnabled=YES;
        _scrollview.showsHorizontalScrollIndicator=NO;
        _scrollview.contentOffset=CGPointMake(CGRectGetWidth(self.scrollview.frame), 0);
    }
    return _scrollview;
}
-(void)setupImageView{
    self.leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*0, 0, self.frame.size.width, self.frame.size.height)];
    self.centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*1, 0, self.frame.size.width, self.frame.size.height)];
    self.rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height)];
    [self.leftImageView sd_setImageWithURL:[self getImageUrlBeforIndex:self.currentPage]];
    [self.centerImageView sd_setImageWithURL:[self getImageUrlAtIndex:self.currentPage]];
    [self.rightImageView sd_setImageWithURL:[self getImageUrlAfterIndex:self.currentPage]];
    
    self.leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    ///用户看到的只有中间视图，所以为了简单起见，只需要添加中间视图的点击响应
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap)];
    self.centerImageView.userInteractionEnabled =  YES;
    [self.centerImageView addGestureRecognizer:tap];
    
    [self.scrollview addSubview:self.leftImageView];
    [self.scrollview addSubview:self.centerImageView];
    [self.scrollview addSubview:self.rightImageView];
}
-(void)setupTimer{
    self.timer=[NSTimer timerWithTimeInterval:self.intervalTime target:[CRZWeakTarget weakTarget:self] selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)timerTick{
    self.currentPage++;
    if (self.currentPage==self.imageUrls.count) {
        self.currentPage=0;
    }
    [UIView animateWithDuration:1 animations:^{
        self.centerImageView.userInteractionEnabled=NO;
        self.scrollview.contentOffset=CGPointMake(CGRectGetWidth(self.scrollview.frame)*2, 0);
    } completion:^(BOOL finished) {
        self.centerImageView.userInteractionEnabled=YES;
        self.leftImageView.image=self.centerImageView.image;
        self.centerImageView.image=self.rightImageView.image;
        self.scrollview.contentOffset=CGPointMake(CGRectGetWidth(self.frame)*1, 0);
        [self.rightImageView  sd_setImageWithURL:[self getImageUrlAfterIndex:self.currentPage]];
        self.pageControl.currentPage=self.currentPage;
    }];
}
-(void)imageViewTap{
    //NSLog(@"tap at :%ld",self.currentPage);
    [self.delegate CRZScrollview:self selected:self.currentPage];
}
-(NSURL *)getImageUrlBeforIndex:(NSInteger)index{
    if (index==0) {
        return [self.imageUrls lastObject];
    }else{
        return self.imageUrls[index-1];
    }
}
-(NSURL *)getImageUrlAfterIndex:(NSInteger)index{
    if (index==self.imageUrls.count-1){
        return self.imageUrls.firstObject;
    }else{
        return self.imageUrls[index+1];
    }
}
-(NSURL *)getImageUrlAtIndex:(NSInteger)index{
    if (index<0||index>=self.imageUrls.count) {
        return nil;
    }else{
        return self.imageUrls[index];
    }
}
#pragma mark 滑动事件
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setupTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (index==0) {
        //左滑
        self.currentPage--;
        if (self.currentPage<0) {
            self.currentPage=self.imageUrls.count-1;
        }
        self.rightImageView.image=self.centerImageView.image;
        self.centerImageView.image=self.leftImageView.image;
        scrollView.contentOffset=CGPointMake(CGRectGetWidth(self.scrollview.frame)*1, 0);
        [self.leftImageView sd_setImageWithURL:[self getImageUrlBeforIndex:self.currentPage]];
        self.pageControl.currentPage=self.currentPage;
    }else if (index==2){
        self.currentPage++;
        if (self.currentPage==self.imageUrls.count) {
            self.currentPage=0;
        }
        self.leftImageView.image=self.centerImageView.image;
        self.centerImageView.image=self.rightImageView.image;
        scrollView.contentOffset=CGPointMake(CGRectGetWidth(self.scrollview.frame)*1, 0);
        [self.rightImageView sd_setImageWithURL:[self getImageUrlAfterIndex:self.currentPage]];
        self.pageControl.currentPage=self.currentPage;
    }
}

@end
