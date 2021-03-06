//
//  NearbyViewController.m
//  LuoMiPhone
//
//  Created by Tim Geng on 3/27/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "NearbyViewController.h"
#import "JSDropDownMenu.h"
#import "JSIndexPath.h"
#import "LocationTableViewCell.h"
#import "GroupByListTableViewCell.h"
#import "ListHeaderView.h"
#import "ListFooterView.h"
#import "ListTableView.h"

#define LocationTableViewCellIdentifier @"LocationTableViewCellIdentifier"
#define groupByListTableViewCellIdentifier @"GroupByListTableViewCell"


@interface NearbyViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSMutableArray *_data4;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData4Index;
    
    NSInteger _currentData1SelectedIndex;
    JSDropDownMenu *menu;
    
}

@property(nonatomic,strong) GroupByListModal *groupListModal;

@property(nonatomic,strong) NSMutableDictionary *rowsNumberForSection;
@property(nonatomic,strong) NSMutableDictionary *sectionFooterViewHight;
@property(nonatomic,strong) NSMutableDictionary *sectionFooterView;

@end

@implementation NearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentData1Index = 1;
    _currentData1SelectedIndex = 1;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"mc"],@"image",@"1毛钱吃麦当劳",@"listTitle",@"1毛钱吃麦当劳原味板烧鸡腿堡",@"listDetail",@"￥0.1",@"listPrice",@"已售344245",@"listSales", nil];
    self.groupListModal = [[GroupByListModal alloc] initWith:dic];
     [self.tableView registerNib:[UINib nibWithNibName:groupByListTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:groupByListTableViewCellIdentifier];
    NSArray *quanbufenlei = @[];
    NSArray *jinrixindan = @[];
    NSArray *dianying = @[];
    NSArray *meishi = @[@"全部", @"全部中餐", @"小吃快餐", @"火锅", @"自助餐"];
    NSArray *jiudian = @[@"全部",@"经济型酒店",@"快捷酒店",@"青年旅社",@"钟点房",@"商务酒店"];
    
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"全部分类", @"data":quanbufenlei}, @{@"title":@"今日新单", @"data":jinrixindan},@{@"title":@"电影", @"data":dianying}, @{@"title":@"美食", @"data":meishi} , @{@"title":@"酒店", @"data":jiudian}, nil];
    _data2 = [NSMutableArray arrayWithObjects: @"全城", @"500m", @"1km", @"3km", @"5km",  nil];
    _data3 = [NSMutableArray arrayWithObjects:@"默认排序", @"离我最近", @"评价最高", @"最新发布", @"销量最高", @"价格最低", @"价格最高", nil];
    _data4 = [NSMutableArray arrayWithObjects:@"筛选",  nil];
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    // menu.textColor = [UIColor redColor];
    
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    self.title = @"附近";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LocationTableViewCell class]) bundle:nil] forCellReuseIdentifier:LocationTableViewCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowsNumberForSection = [[NSMutableDictionary alloc] init];
    self.sectionFooterViewHight = [[NSMutableDictionary alloc] init];
    self.sectionFooterView = [[NSMutableDictionary alloc] init];
    for (int i = 1; i < 7; i++) {
        [self.rowsNumberForSection setValue:[NSNumber numberWithInt:2]
                                     forKey:[NSString stringWithFormat:@"%d",i]];
        [self.sectionFooterViewHight setValue:[NSNumber numberWithInt:50]
                                     forKey:[NSString stringWithFormat:@"%d",i]];
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ListFooterView" owner:self options:nil];
        ListFooterView *footerView = (ListFooterView *)[views lastObject];
        footerView.section = i;
        [self.sectionFooterView setValue:footerView forKey:[NSString stringWithFormat:@"%d",i]];
        footerView.footerViewClicked = ^(NSInteger section){
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:section];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:3 inSection:section];
            NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath1,indexPath2,nil];
            //同样，将数据加到list中，用的row
            [self.rowsNumberForSection setValue:[NSNumber numberWithInt:4]
                                         forKey:[NSString stringWithFormat:@"%d",(int)section]];
            [self.sectionFooterViewHight setValue:[NSNumber numberWithInt:10]
                                           forKey:[NSString stringWithFormat:@"%d",(int)section]];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
            view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            [self.sectionFooterView setValue:view forKey:[NSString stringWithFormat:@"%d",i]];
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
    }
    
    // Do any additional setup after loading the view from its nib.
}

#pragma uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    int i = (int)section;
    NSNumber *number = [self.rowsNumberForSection objectForKey:[NSString stringWithFormat:@"%d",i]];
    return number.integerValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LocationTableViewCell *locationCell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:LocationTableViewCellIdentifier forIndexPath:indexPath];
        locationCell.contentView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        [locationCell update:nil];
        return locationCell;
    }else{
        static NSString *GroupByListTableViewCellIdentifier = groupByListTableViewCellIdentifier;
        GroupByListTableViewCell *cell = (GroupByListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GroupByListTableViewCellIdentifier forIndexPath:indexPath];
        [cell setGroupByListModal:self.groupListModal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ListHeaderView" owner:self options:nil];
    if (section != 0) {
        ListHeaderView *headerView = (ListHeaderView *)[views lastObject];
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    if (section != 0) {
        UIView *footerView = [self.sectionFooterView objectForKey:[NSString stringWithFormat:@"%d",(int)section]];
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section!=0) {
        NSNumber *number = [self.sectionFooterViewHight objectForKey:[NSString stringWithFormat:@"%d",(int)section]];
        return number.floatValue;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 40;
    }
    return 0;}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        return 97;
    }
    return 30;
}



- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 4;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    
    if([[_data1[column] objectForKey:@"data"] count] == 0){
        
        return NO;
    }
    
    return YES;
    
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.5;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    } else if (column== 3){
        return _data4.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
            if ([[_data1[_currentData1Index] objectForKey:@"data"] count] == 0) {
                return  [_data1[_currentData1Index] objectForKey:@"title"];
            }
            return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: return _data3[_currentData3Index];
            break;
        case 3: return _data4[_currentData4Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else if(indexPath.column == 2){
        
        _currentData3Index = indexPath.row;
    } else {
        _currentData4Index = indexPath.row;
    }
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
