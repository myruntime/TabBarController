//
//  HomeViewController.m
//  ZHLTabBarController
//
//  Created by 朱胡亮 on 2017/2/24.
//  Copyright © 2017年 ZHL. All rights reserved.
//

#import "HomeViewController.h"
#import "QDSearchViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    UIButton *chooseCityBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
    
    chooseCityBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    chooseCityBtn.center = self.view.center;
    [chooseCityBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [chooseCityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
    [chooseCityBtn addTarget:self action:@selector(onClickChooseCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseCityBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickChooseCity:(id)sender {
    
    QDSearchViewController *searchVC = [[QDSearchViewController alloc] init];
    searchVC.completHandle = ^(NSString *city){
        [chooseCityBtn setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:searchVC animated:YES];
    
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:searchVC] animated:YES completion:^{
//        
//    }];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
