//
//  QDCityModle.m
//  TabBarController
//
//  Created by 朱胡亮 on 2017/3/1.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import "QDCityModle.h"
#import "QDCityList.h"
#import "QDCityGroup.h"

@implementation QDCityModle
+ (instancetype)sharedObject
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSArray *)getCityList {
    NSArray<NSDictionary *> *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
    NSMutableArray *cityGroupArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        //首先获取大写首字母（如A）
        QDCityGroup *group = [[QDCityGroup alloc] init];
        group.groupName = [dic objectForKey:@"initial"];
        
        NSArray<NSDictionary *> *cityArray = [dic objectForKey:@"citys"];
        for (NSDictionary *dic in cityArray) {
            
            QDCityList *city = [[QDCityList alloc] init];
            city.cityID = [dic objectForKey:@"city_key"];
            city.cityName = [dic objectForKey:@"city_name"];
            city.shortName = [dic objectForKey:@"short_name"];
            city.pinyin = [dic objectForKey:@"pinyin"];
            city.initials = [dic objectForKey:@"initials"];
            [group.arrayCitys addObject:city];
        }
        [cityGroupArray addObject:group];
    }
    return cityGroupArray;
}



- (NSMutableArray *)citiesArrary {
    if (!_citiesArrary) {
        _citiesArrary = [NSMutableArray arrayWithArray:[self getCityList]];
    }
    return _citiesArrary;
}
@end
