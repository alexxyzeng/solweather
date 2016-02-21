//
//  XYLeftMenuViewController.m
//
//
//  Created by xiayao on 16/2/13.
//
//

#import "XYLeftMenuViewController.h"

@interface XYLeftMenuViewController ()
/**
 *  天气城市列表视图
 */
@property (nonatomic, strong) UITableView *locationTableView;
@property (nonatomic, strong) UIBarButtonItem *editBtn;
/**
 *  确定按钮
 */
@property (nonatomic, strong) UIBarButtonItem *doneBtn;
/**
 *  导航条
 */
@property (nonatomic, strong) UINavigationBar *navBar;
@end

@implementation XYLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgimage"]];
        self.view.opaque = NO;
        
        //设置导航条
        _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
        _navBar.translucent = YES;
        _navBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        
        
        //设置确定按钮
//        _doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItem target:self action:@selector(doneBtnClicked)];
        _doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked)];
        //        襄樊
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"天气城市列表"];
        navItem.rightBarButtonItem = _doneBtn;
//        navItem.leftBarButtonItem = self.editButtonItem;
        [_navBar setItems:@[navItem]];
        [self.view addSubview:_navBar];
        [self initLocationTableView];
        
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_locationTableView setEditing:YES animated:YES];

    [_locationTableView reloadData];
    
}

- (void)initLocationTableView
{
    _locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), self.view.center.y) style:UITableViewStylePlain];
    
    _locationTableView.dataSource = self;
    _locationTableView.delegate = self;
    
    _locationTableView.backgroundColor = [UIColor clearColor];
    _locationTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:_locationTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneBtnClicked
{
    [self.delegate dismissXYLeftMenuViewController];
}

#pragma mark UITableView代理方法

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  返回修改样式为删除
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSNumber *weatherViewTag = [_locations[indexPath.row] lastObject];
        //在代理中移除相应的天气视图
        [self.delegate didRemoveWeatherViewWithTag:weatherViewTag.integerValue];
        //在位置列表中移除
        [_locations removeObjectAtIndex:indexPath.row];
        //删除改行并重新加载列表
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //获取对应行的数据，从城市列表数据中移除
    NSArray *locationArr = _locations[sourceIndexPath.row];
    [_locations removeObjectAtIndex:sourceIndexPath.row];
    //再重新插入
    [_locations insertObject:locationArr atIndex:destinationIndexPath.row];
    
    [self.delegate didMoveWeatherViewAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}
#pragma mark UITableView数据源方法
//实现cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *location = _locations[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   %@", location.firstObject, location[1]];
    
    return cell;
}
//获取行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _locations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
