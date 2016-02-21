//
//  XYRightViewController.m
//  
//
//  Created by xiayao on 16/2/13.
//
//

#import "XYRightViewController.h"

@interface XYRightViewController ()
/**
 *  地理信息编码
 */
@property (nonatomic, strong) CLGeocoder *geocoder;
/**
 *  搜索结果
 */
@property (strong, nonatomic) NSMutableArray *searchResults;
/**
 *  搜索控制器
 */
@property (strong, nonatomic) UISearchDisplayController *searchController;
/**
 *  搜索栏
 */
@property (strong, nonatomic) UISearchBar *searchBar;
/**
 *  导航条
 */
@property (strong, nonatomic) UINavigationBar *navBar;
/**
 *  确定按钮
 */
@property (strong, nonatomic) UIBarButtonItem *doneBtn;
@end

@implementation XYRightViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
        
        _geocoder = [[CLGeocoder alloc] init];
        _searchResults = [[NSMutableArray alloc] initWithCapacity:8];
        _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        [self.view addSubview:_navBar];
        
        _doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClicked)];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 64)];
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.placeholder = @"城市名称";
        _searchBar.delegate = self;
        
        _searchController =[[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsTitle = @"添加天气城市";
        _searchController.displaysSearchBarInNavigationBar = YES;
        _searchController.navigationItem.rightBarButtonItems = @[_doneBtn];
        _navBar.items = @[_searchController.navigationItem];
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchController setActive:YES animated:NO];
    [_searchController.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchController setActive:NO animated:NO];
    [_searchController.searchBar resignFirstResponder];
}

//点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate dismissXYRightViewController];
}

- (void)doneBtnClicked
{
    [self.delegate dismissXYRightViewController];
}

#pragma mark 搜索显示控制器的代理方法
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_geocoder geocodeAddressString:searchString completionHandler:^(NSArray *placemarks, NSError *error) {
        _searchResults = [NSMutableArray arrayWithCapacity:5];
        for (CLPlacemark *placemark in placemarks) {
            [_searchResults addObject:placemark];
        }
        [controller.searchResultsTableView reloadData];
    }];
    
    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setFrame:CGRectMake(0, CGRectGetHeight(_navBar.bounds), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_navBar.bounds))];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    [self.view bringSubviewToFront:_navBar];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    // Dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure cell for the search results table view
    if(tableView == _searchController.searchResultsTableView) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        //  获取列表对应的搜索结果
        CLPlacemark *placemark = self.searchResults[indexPath.row];
        //  将地理位置转化为国家和城市的字符串
        NSString *city = placemark.locality;
        NSString *country = placemark.country;
        NSString *cellText = [NSString stringWithFormat:@"%@, %@", city, country];
        
        cell.textLabel.text = cellText;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.searchController.searchResultsTableView) {
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        CLPlacemark *placemark = [self.searchResults objectAtIndex:indexPath.row];
        [self.delegate didAddLocationWithPlacemark:placemark];
        [self.delegate dismissXYRightViewController];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _navBar.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, CGRectGetWidth(_navBar.frame), CGRectGetHeight(_navBar.frame));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
