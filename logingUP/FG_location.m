//
//  FG_location.m
//  logingUP
//
//  Created by 王放歌 on 2018/9/26.
//  Copyright © 2018年 WangFangGe. All rights reserved.
//

#import "FG_location.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreLocation/CoreLocation.h>

@interface FG_location() <CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation FG_location
- (void)FGLog_startLocating{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark 定位代理
/* 定位完成后 回调 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *loc = [locations firstObject];
    
    CLLocationCoordinate2D coordinate = loc.coordinate;
    //  经纬度
    NSLog(@"---x:%f---y:%f",coordinate.latitude,coordinate.longitude);
    
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //NSLog(@%@,placemark.name);//具体位置
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"所在城市:%@",city);
            
            if (city.length == 0) {
                city = @"";
            }
            
            
            NSString *area = placemark.subLocality;
            NSLog(@"所在区域:%@",area);
            if (area.length == 0) {
                area = @"";
            }
            
            
            NSString *country = placemark.country;
            NSLog(@"所在国家:%@",country);
            if (country.length == 0) {
                country = @"";
            }
            [self.delegate changeLocation:country city:city area:area coord:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude]];
        }

        
        
        [manager stopUpdatingLocation];   //停止定位
    }];
    
    
}

/* 定位失败后 回调 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错
        NSLog(@"定位失败");
        
    }
    [self.delegate changeLocation:@"" city:@"" area:@"" coord:@""];

}
@end
