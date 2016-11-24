//
//  UISlider+WJXSege.h
//  balanceCar
//
//  Created by jancee wang on 16/8/18.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (WJXSege)
- (CGFloat)segeSliderDealSegeCount:(NSUInteger)segeCount
                      realValueMin:(CGFloat)realValueMin
                      realValueMax:(CGFloat)realValueMax;


- (CGFloat)setSegeSliderPosition:(CGFloat)position
                       segeCount:(NSUInteger)segeCount
                    realValueMin:(CGFloat)realValueMin
                    realValueMax:(CGFloat)realValueMax;
@end
