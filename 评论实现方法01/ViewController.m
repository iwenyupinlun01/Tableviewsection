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
#import "keyBoardToolView.h"
#import "XYView.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,keyBoardToolViewDelegate>
@property (nonatomic,strong) UITableView *maintable;
@property (nonatomic,strong) UIView *headview;

@property (nonatomic,strong) pinglunmodel *cellmodel;
@property (nonatomic, strong) NSMutableArray *carGroups;

@property (nonatomic,strong) NSMutableArray *sonCommentarr;

@property (nonatomic,strong) NSMutableArray *pinglunarr;

@property (nonatomic ,strong)XYView *views;
@property (nonatomic, assign) CGFloat keyBoardHeight;

@end
static NSString *cellidentfid = @"cellidentfid";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //[self addHeader];
    [self datafromweb];


    [self.view addSubview:self.maintable];
    //利用通知中心监听键盘的显示和消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.views = [XYView XYveiw];
    
    self.views.frame = CGRectMake(0,self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    [self.views.btn addTarget:self action:@selector(ceacllBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.views];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}




-(void)datafromweb
{
    
    

    
    NSLog(@"arr=========%@",_carGroups);
    
    self.pinglunarr = [NSMutableArray array];
    
    
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
            
            
            [self.carGroups addObject:self.cellmodel];
        }
        NSLog(@"sonComment---------------%@",self.pinglunarr);
        
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
//    for (int i = 0; i<cg.cars.count; i++) {
//        NSDictionary *dit = [cg.cars objectAtIndex:i];
//        NSString *str = [dit objectForKey:@"content"];
//        [self.pinglunarr addObject:str];
//    }
    // 设置cell显示的文字
    cell.textLabel.text = car;
    //cell.textLabel.text = self.pinglunarr[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"12");
    [self.views.textTF becomeFirstResponder];
}

- (void)handleKeyBoardAction:(NSNotification *)notification {
    NSLog(@"%@",notification);
    //1、计算动画前后的差值
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat detalY = endFrame.origin.y - beginFrame.origin.y;
    
    //2、根据差值更改_textView的高度
    CGFloat frame = self.views.frame.origin.y;
    frame += detalY;
    self.views.frame = CGRectMake(0, frame, self.view.frame.size.width, 40);
    
}

- (void)ceacllBtn:(id)sender {
    
    [_views.textTF resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




@end
