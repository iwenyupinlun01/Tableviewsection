//
//  ViewController.m
//  评论实现方法01
//
//  Created by 王俊钢 on 2017/4/20.
//  Copyright © 2017年 wangjungang. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "pinglunmodel.h"
#import "AFManager.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *maintable;
@property (nonatomic,strong) UIView *headview;

@property (nonatomic,strong) pinglunmodel *cellmodel;
@property (nonatomic, strong) NSMutableArray *carGroups;

@property (nonatomic,strong) NSMutableArray *sonCommentarr;

@end
static NSString *cellidentfid = @"cellidentfid";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //[self addHeader];
    [self datafromweb];

    [self.view addSubview:self.maintable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)datafromweb
{
    
    

    
    NSLog(@"arr=========%@",_carGroups);
    
    
    
    
    [AFManager getReqURL:@"http://np.iwenyu.cn/forum/index/detail.html?id=1&page=1&token=" block:^(id infor) {
        //NSLog(@"info============%@",infor);
        NSDictionary *dic = [infor objectForKey:@"info"];
        
        NSMutableArray *commentdic = [NSMutableArray array];
        
        commentdic = [dic objectForKey:@"all_comment"];
        
        NSLog(@"commentdic ----- %@",commentdic);
        self.sonCommentarr = [NSMutableArray array];
        for (int i = 0; i<commentdic.count; i++) {
            
            NSDictionary *dicaaa = [commentdic objectAtIndex:i];
            
            self.cellmodel = [[pinglunmodel alloc] init];
            self.cellmodel.cars = [NSMutableArray array];
            self.cellmodel.cars = [dicaaa objectForKey:@"sonComment"];
            
            [self.sonCommentarr addObject:self.cellmodel.cars];
            
//            for (int j = 0; j<self.sonCommentarr.count; j++) {
//                self.cellmodel.
//                [self.cellmodel.cars addObject:@"12211"];
//            }
            
            
            [self.carGroups addObject:self.cellmodel];
        }
        NSLog(@"sonComment---------------%@",self.sonCommentarr);
        
        [self.maintable reloadData];
    } errorblock:^(NSError *error) {
        
    }];
}


-(NSMutableArray *)carGroups
{
    if(!_carGroups)
    {
        _carGroups = [[NSMutableArray alloc] init];
        
    }
    return _carGroups;
}

- (void)addHeader
{
    
    // 头部刷新控件
    self.maintable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
    [self.maintable.mj_header beginRefreshing];
    
}
- (void)addFooter
{
    self.maintable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshLoadMore)];
}
- (void)refreshAction {
    
    [self headerRefreshEndAction];
    
}
- (void)refreshLoadMore {
    
    [self footerRefreshEndAction];
    
}

-(void)headerRefreshEndAction
{
    
}


-(void)footerRefreshEndAction
{
    
}
#pragma mark - getters

-(UITableView *)maintable
{
    if(!_maintable)
    {
        _maintable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
        _maintable.dataSource = self;
        _maintable.delegate = self;
        _maintable.tableHeaderView = self.headview;
    }
    return _maintable;
}

-(UIView *)headview
{
    if(!_headview)
    {
        _headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        _headview.backgroundColor = [UIColor redColor];
        
    }
    return _headview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.cellmodel = self.carGroups[section];
    return self.cellmodel.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentfid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentfid];
    }
    // 取出第indexPath.section组对应的模型
    pinglunmodel *cg = self.carGroups[indexPath.section];
    // 取车第indexPath.row这行对应的品牌名称
    NSString *car = [cg.cars[indexPath.row] objectForKey:@"content"];
    // 设置cell显示的文字
    cell.textLabel.text = car;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end
