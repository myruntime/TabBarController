//
//  QDCityGroup.m
//  TabBarController
//
//  Created by 朱胡亮 on 2017/3/1.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import "QDCityGroup.h"

@implementation QDCityGroup

- (NSMutableArray *) arrayCitys
{
    if (_arrayCitys == nil) {
        _arrayCitys = [[NSMutableArray alloc] init];
    }
    return _arrayCitys;
}

@end
