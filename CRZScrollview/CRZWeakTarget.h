//
//  WeakTarget.h
//  TimerWeakTarget
//
//  Created by ChenQing on 17/9/25.
//  Copyright © 2017年 ChenQing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRZWeakTarget : NSObject

/**
 弱饮用target

 @param target <#sender description#>
 @return <#return value description#>
 */
+(instancetype)weakTarget:(id)target;

-(instancetype)initWithTarget:(id)target;

@end
