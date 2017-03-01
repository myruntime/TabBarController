//
//  QDCityGroup.h
//  TabBarController
//
//  Created by 朱胡亮 on 2017/3/1.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDCityGroup : NSObject

/*
 *  分组标题
 */
@property (nonatomic, strong) NSString *groupName;

/*
 *  城市数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCitys;

@end
