//
//  QDCityModle.h
//  TabBarController
//
//  Created by 朱胡亮 on 2017/3/1.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDCityList : NSObject
/*
 *  城市ID
 */
@property (nonatomic, strong) NSString *cityID;

/*
 *  城市名称
 */
@property (nonatomic, strong) NSString *cityName;

/*
 *  短名称
 */
@property (nonatomic, strong) NSString *shortName;

/*
 *  城市名称-拼音
 */
@property (nonatomic, strong) NSString *pinyin;

/*
 *  城市名称-拼音首字母
 */
@property (nonatomic, strong) NSString *initials;


@end
