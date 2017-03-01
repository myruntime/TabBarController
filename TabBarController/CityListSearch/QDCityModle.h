//
//  QDCityModle.h
//  TabBarController
//
//  Created by 朱胡亮 on 2017/3/1.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDCityModle : NSObject
+ (instancetype)sharedObject;
/*
 *  城市数组
 */
@property (nonatomic, strong) NSMutableArray *citiesArrary;





@end
