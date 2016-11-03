//
//  LeftViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/22.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *array;
    
    UITableView *_tableView;
    NSInteger _rowIndex;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    array = @[@"无",@"滑动",@"滑动 & 缩放",@"3D旋转",@"视差滑动"];
    _rowIndex = 0;
    
    [self createTableView];
}

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return array.count;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = array[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == _rowIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _rowIndex = indexPath.row;
    
    [_tableView reloadData];
    
    // 改变滑动类型
    
    MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
    
    manager.leftDrawerAnimationType = indexPath.row;
    manager.rightDrawerAnimationType = indexPath.row;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
