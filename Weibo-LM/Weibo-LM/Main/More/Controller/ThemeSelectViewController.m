//
//  ThemeSelectViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "ThemeSelectViewController.h"

@interface ThemeSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSDictionary *_themeData;
}
@end

@implementation ThemeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.separatorColor = [[ThemeManager shareManager] getThemeColorWithColorName:@"More_Item_Line_color"];
    [self loadData];
    [self createTableView];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
    _themeData = [[NSDictionary alloc]initWithContentsOfFile:path];
    
}

-(void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _themeData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"themeCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSArray *themeNames = _themeData.allKeys;
    NSString *currentThemeName = themeNames[indexPath.row];
    cell.textLabel.text = currentThemeName;
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",_themeData[currentThemeName],@"more_icon_theme.png"];
    UIImage *img = [UIImage imageNamed:imagePath];
    cell.imageView.image = img;
    
    if([currentThemeName isEqualToString:[ThemeManager shareManager].currentThemeName]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.textColor = [[ThemeManager shareManager]getThemeColorWithColorName:@"More_Item_Text_color"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *themeName = cell.textLabel.text;
    
    [[ThemeManager shareManager]setCurrentThemeName:themeName];
    
    tableView.separatorColor = [[ThemeManager shareManager] getThemeColorWithColorName:@"More_Item_Line_color"];
    
    [tableView reloadData];
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
