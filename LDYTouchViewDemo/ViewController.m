//
//  ViewController.m
//  LDYTouchViewDemo
//
//  Created by yang on 2017/5/29.
//  Copyright © 2017年 com.tixa.SealChat. All rights reserved.
//

#import "ViewController.h"
#import "ContactActivityTouchView.h"
#import "Activity.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ContactActivityTouchViewDelegate>
@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) ContactActivityTouchView      *contactActivityTouchView;
@property (nonatomic, strong) NSMutableArray                *dataArray;
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    for (int i = 0; i < 10; i++) {
        Activity *activity = [[Activity alloc]init];
        [_dataArray addObject:activity];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createContactTouchView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeContactActivityTouchView];
}
- (void)createTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(cellRect.size.width - 100.0f, cellRect.size.height - 50.0f, 37.0f, 37.0f)];
        [commentButton setImage:[UIImage imageNamed:@"activity_comment_image"] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"activity_comment_image_selected"] forState:UIControlStateSelected];
        commentButton.tag = 10001;
        [cell.contentView addSubview:commentButton];
        
        UIButton *praiseButton = [[UIButton alloc]initWithFrame:CGRectMake(cellRect.size.width - 50.0f, cellRect.size.height - 50.0f, 37.0f, 37.0f)];
        [praiseButton setImage:[UIImage imageNamed:@"activity_praise_image"] forState:UIControlStateNormal];
        [praiseButton setImage:[UIImage imageNamed:@"activity_praise_image_selected"] forState:UIControlStateSelected];
        praiseButton.tag = 10002;
        [cell.contentView addSubview:praiseButton];
    }
    Activity *activity = self.dataArray[indexPath.row];
    UIButton *commentButton = [cell.contentView viewWithTag:10001];
    commentButton.selected = activity.isComment;
    UIButton *praiseButton = [cell.contentView viewWithTag:10002];
    praiseButton.selected = activity.isPraise;
    
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld\nrow:%ld",indexPath.section,indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - ContactActivityTouchViewDelegate
- (void)contactActivityTouchView:(ContactActivityTouchView *)contactActivityTouchView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    Activity *activity = nil;
    NSIndexPath *indexPath = [contactActivityTouchView indexPathOfTableView:self.tableView withTouches:touches];
    if (indexPath) {
        NSLog(@"selected section:%ld\n    row:%ld",indexPath.section,indexPath.row);
        activity = self.dataArray[indexPath.row];
    }
    if (contactActivityTouchView.praiseButton.selected) {
        NSLog(@"点赞");
        activity.isPraise = !activity.isPraise;
    }
    if (contactActivityTouchView.commentButton.selected) {
        NSLog(@"评论");
        activity.isComment = !activity.isComment;
    }
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)contactActivityTouchView:(ContactActivityTouchView *)contactActivityTouchView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    }
- (void)contactActivityTouchEndedToRemoveTouchView:(ContactActivityTouchView *)contactActivityTouchView
{
    [self removeContactActivityTouchView];
    
}
- (void)createContactTouchView
{
    if (!_contactActivityTouchView) {
        _contactActivityTouchView = [[ContactActivityTouchView alloc]init];
        _contactActivityTouchView.delegate = self;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_contactActivityTouchView];
    [_contactActivityTouchView.superview bringSubviewToFront:_contactActivityTouchView];
}
- (void)removeContactActivityTouchView
{
    if (_contactActivityTouchView) {
        [_contactActivityTouchView removeFromSuperview];
        _contactActivityTouchView = nil;
    }
}

@end
