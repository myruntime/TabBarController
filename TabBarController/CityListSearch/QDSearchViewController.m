//
//  QDSearchViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/5/25.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDSearchViewController.h"

#import "QDCityList.h"
#import "QDCityGroup.h"
#import "QDCityModle.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface QDSearchViewController ()<QMUISearchControllerDelegate,CLLocationManagerDelegate>

//@property(nonatomic,strong) NSArray<NSString *> *keywords;


@property(nonatomic,strong) NSArray *cityArray;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,strong) NSString *currentCity;



@property(nonatomic,strong) NSMutableArray *searchResultsKeywords;
@property(nonatomic,strong) QMUISearchController *mySearchController;
@end

@implementation QDSearchViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.cityArray = [[QDCityModle sharedObject] citiesArrary];
        self.searchResultsKeywords = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"城市选择"];
    [self locationStart];
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
}

#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>

- (BOOL)shouldShowSearchBarInTableView:(QMUITableView *)tableView {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.cityArray.count+2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return 1;
        }else {
            //
            QDCityGroup *group = self.cityArray[section-2];
            return group.arrayCitys.count;
        }
        
    }
    return self.searchResultsKeywords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:self.tableView withReuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            cell.textLabel.text = self.currentCity?self.currentCity:@"定位中...";
        }else if (indexPath.section == 1) {
            cell.textLabel.text = @"无历史";
        }else {
            QDCityGroup *group = self.cityArray[indexPath.section-2];
            QDCityList *city = group.arrayCitys[indexPath.row];
            cell.textLabel.text = city.cityName;
        }
        
    } else {
        QDCityList *city = self.searchResultsKeywords[indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:city.cityName attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
        NSRange range = [city.cityName rangeOfString:self.mySearchController.searchBar.text];
        if (range.location != NSNotFound) {
            [attributedString addAttributes:@{NSForegroundColorAttributeName: UIColorBlue} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 0) {
            return @"当前城市";
        }else if (section == 1) {
            return @"历史记录";
        }else {
            QDCityGroup *group = self.cityArray[section-2];
            return group.groupName;
        }
    }else {
        return @"搜索结果";
    }
    
}



#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        
    }else {
        
    }
}


#pragma mark - <QMUISearchControllerDelegate>

- (void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString {
    [self.searchResultsKeywords removeAllObjects];
    
    for (QDCityGroup *group in self.cityArray){
        for (QDCityList *city in group.arrayCitys) {
            if ([city.cityName qmui_includesString:searchString] || [city.pinyin qmui_includesString:searchString] || [city.initials qmui_includesString:searchString]) {
                [self.searchResultsKeywords addObject:city];
            }
        }
    }
    [searchController.tableView reloadData];
    
    if (self.searchResultsKeywords.count == 0) {
        [searchController showEmptyViewWithText:@"没有匹配结果" detailText:nil buttonTitle:nil buttonAction:NULL];
    } else {
        [searchController hideEmptyView];
    }
}

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    [QMUIHelper renderStatusBarStyleDark];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    BOOL oldStatusbarLight = NO;
    if ([self respondsToSelector:@selector(shouldSetStatusBarStyleLight)]) {
        oldStatusbarLight = [self shouldSetStatusBarStyleLight];
    }
    if (oldStatusbarLight) {
        [QMUIHelper renderStatusBarStyleLight];
    } else {
        [QMUIHelper renderStatusBarStyleDark];
    }
}








#pragma mark 开始定位

- (void)locationStart {
    //判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
    }
}

#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *) locations {
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
         if (array.count >0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市  subLocality(xx区)   placemark.name （无锡惠山经济开发区） placemark.administrativeArea （江苏省）
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             self.currentCity = currCity;
             [self.tableView reloadData];
         }else if (error ==nil && [array count] == 0) {
             NSLog(@"No results were returned.");
         }else if (error !=nil) {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


@end
