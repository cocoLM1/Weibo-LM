//
//  LocationViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/25.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SinaWeibo.h"

@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *_locationManager;
    BOOL _isLocation;
    NSArray *_poisArray;
    
    UITableView *_tableView;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"附近地点";
    _isLocation = NO;
    [self startLocation];
    [self createTableView];
}

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

// 开启定位
-(void)startLocation{
    _locationManager = [[CLLocationManager alloc]init];
    
    
    // 请求定位权限
    if (kSystemVersion >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    // 设置定位精准值
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // 设置代理,获取定位结果
    _locationManager.delegate = self;
    
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 避免多次定位
    if (_isLocation) {
        return;
    }
    _isLocation = YES;
    // 获取后 关闭定位
    [_locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject];
    
    NSLog(@"%@",location);
    
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    
    NSDictionary *dic = @{@"lat" : [NSString stringWithFormat:@"%f",latitude],
                          @"long" : [NSString stringWithFormat:@"%f",longitude]};
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    SinaWeibo *weibo = delegate.sinaWeibo;
    
    [weibo requestWithURL:@"place/nearby/pois.json" params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    // 读取位置信息
    _poisArray = dic[@"pois"];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _poisArray.count;
}
//
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    // 填充数据
//    NSDictionary *dic = _poisArray[indexPath.row];
//    cell.textLabel.text = dic[@"title"];
//    cell.detailTextLabel.text = dic[@"address"];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];

    return cell;
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
