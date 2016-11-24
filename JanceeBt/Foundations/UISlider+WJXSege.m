//
//  UISlider+WJXSege.m
//  balanceCar
//
//  Created by jancee wang on 16/8/18.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "UISlider+WJXSege.h"

@implementation UISlider (WJXSege)

/**
 *  @brief 分段将slider的滑条移到最靠近的位置
 *
 *  @param segeCount
 *  @param realValueMin
 *  @param realValueMax
 *
 *  @return 当前段位真实值
 */
- (CGFloat)segeSliderDealSegeCount:(NSUInteger)segeCount
                      realValueMin:(CGFloat)realValueMin
                      realValueMax:(CGFloat)realValueMax {
  CGFloat selectRealValue;
  CGFloat eachRange = 1.0 / (segeCount - 1);
  CGFloat rangeCenter = eachRange / 2;
  CGFloat realStep = (realValueMax - realValueMin) / (segeCount - 1);
  NSUInteger i;
  for (i = 0; i < (segeCount - 1); i++) {
    if(self.value >= (1.0 - rangeCenter - (i * eachRange))) {
      break;
    }
  }
  selectRealValue = realValueMax - realStep * i;
  
  [self setValue:1.0 - eachRange * i animated:YES];
  return selectRealValue;
}





/**
 *  @brief 传入真实值和分段数据，计算出分段位置移动滑块，并返回
 *
 *  @return 当前段位滑条值
 */
- (CGFloat)setSegeSliderPosition:(CGFloat)position
                       segeCount:(NSUInteger)segeCount
                    realValueMin:(CGFloat)realValueMin
                    realValueMax:(CGFloat)realValueMax {
  CGFloat selectRealValue = position;                                     //选择的真实值
  CGFloat eachRange = 1.0 / (segeCount - 1);                              //每段滑条值步进
  CGFloat realStep = (realValueMax - realValueMin) / (segeCount - 1);     //真实值步进
  CGFloat rangeCenter = realStep / 2;                                    //每两端的中间真实值
  
  //判断真实值最接近什么
  NSUInteger i;
  for (i = 0; i < (segeCount - 1); i++) {
    if(selectRealValue >= (realValueMax - rangeCenter - (i * realStep))) {
      break;
    }
  }
  
  [self setValue:1.0 - eachRange * i animated:YES];
  return self.value;
}




@end
