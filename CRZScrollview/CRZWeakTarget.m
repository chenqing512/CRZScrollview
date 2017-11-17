//
//  WeakTarget.m
//  TimerWeakTarget
//
//  Created by ChenQing on 17/9/25.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import "CRZWeakTarget.h"

@interface CRZWeakTarget ()

@property (nonatomic,weak) id target;

@end

@implementation CRZWeakTarget

-(instancetype)initWithTarget:(id)target{
    _target=target;
    return self;
}

+(instancetype)weakTarget:(id)target{
    return [[CRZWeakTarget alloc]initWithTarget:target];
}

/**
 消息转发

 @param aSelector <#aSelector description#>
 @return <#return value description#>
 */
-(id)forwardingTargetForSelector:(SEL)aSelector{
    return _target;
}



@end
