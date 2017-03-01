//
//  ZHLTabBarController.m
//  ZHLTabBarController
//
//  Created by 朱胡亮 on 2017/2/24.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import "ZHLTabBarController.h"
#import "HomeViewController.h"
#import "SetViewController.h"


@interface ZHLTabBarController ()


@end

@implementation ZHLTabBarController
{
    void (^tabBarItemDoubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index);
    NSInteger _index;
    UITabBar *tabbar;
    NSMutableArray *marray;
}

+ (void)initialize {
    
    UITabBarItem *tabBarTtem = [UITabBarItem appearance];
    
    NSMutableDictionary *noselDic = [NSMutableDictionary dictionary].mutableCopy;
    noselDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    noselDic[NSForegroundColorAttributeName] = [UIColor redColor];
    [tabBarTtem setTitleTextAttributes:noselDic forState:UIControlStateNormal];
    
    NSMutableDictionary *selDic = [NSMutableDictionary dictionary].mutableCopy;
    selDic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    selDic[NSForegroundColorAttributeName] = [UIColor redColor];
    [tabBarTtem setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    marray = [NSMutableArray array];
    // 双击 tabBarItem 的回调
    _index = 0;
    __weak __typeof(self)weakSelf = self;
    tabBarItemDoubleTapBlock = ^(UITabBarItem *tabBarItem, NSInteger index) {
        if (_index == index) {
             NSLog(@"双击了第%ld个",(long)index);
        }else {
           
        }
//        [weakSelf.tabBar qmui_setSelectedItem:tabBarItem];
        _index = index;
        
    };
    [self setTabbar];
    

}

- (void)setTabbar {

    [self setChildViewController:[[HomeViewController alloc] init] noselImage:[UIImage imageNamed:@"item1Nor"] selImage:[UIImage imageNamed:@"item1Select"] title:@"Home"];
    [self setChildViewController:[[HomeViewController alloc] init] noselImage:[UIImage imageNamed:@"item2Nor"] selImage:[UIImage imageNamed:@"item2Select"] title:@"1"];
    [self setChildViewController:[[HomeViewController alloc] init] noselImage:[UIImage imageNamed:@"item3Nor"] selImage:[UIImage imageNamed:@"item3Select"] title:@"2"];
    [self setChildViewController:[[HomeViewController alloc] init] noselImage:[UIImage imageNamed:@"item4Nor"] selImage:[UIImage imageNamed:@"item4Select"] title:@"3"];
    
    [self setChildViewController:[[SetViewController alloc] init] noselImage:[UIImage imageNamed:@"item5Nor"] selImage:[UIImage imageNamed:@"item5Select"] title:@"Set"];
    
    
    /** 设置tabar工具条 */
    [self.tabBar setBackgroundImage:[self imageWithColor:[UIColor cyanColor] size:self.tabBar.frame.size]];
    self.tabBar.tintColor = [UIColor redColor];
    self.hidesBottomBarWhenPushed = YES;
    //    [self.tabBar setShadowImage:[UIImage new]];
    
    //    [self.tabBar showBadgeOnItemIndex:1];
    
//    tabbar = [[UITabBar alloc] init];
//    tabbar.tintColor = UIColorFromRGB(0x34B1E0);
//    [self.tabBar addSubview:tabbar];
//    tabbar.items = self.tabBar.items;
}


- (void)setChildViewController:(UIViewController *)childvc noselImage:(UIImage *)noselImg selImage:(UIImage *)selImg title:(NSString *)titleStr {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childvc];
//    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:titleStr image:[noselImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    
//    nav.tabBarItem = tabBarItem;
//    [marray addObject:tabBarItem];
    
    childvc.title = titleStr;
    childvc.tabBarItem.image = [noselImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childvc.tabBarItem.selectedImage = [selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childvc.tabBarItem.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.tabBar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.tabBar.frame));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
