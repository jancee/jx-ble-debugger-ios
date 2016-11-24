//
//  SearchDeviceTableViewController.m
//  JanceeBt
//
//  Created by jancee wang on 2016/11/14.
//  Copyright © 2016年 Wang Jingxi. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"

@interface SearchDeviceViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong, readonly) OrderMenuTableViewController  *orderMenuVC;
@property (nonatomic, strong, readonly) FilterMenuTableViewController *filterMenuVC;
@property (nonatomic, strong, readonly) ShowMenuTableViewController   *showMenuVC;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *leftMenuButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightMenuButtonItem;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *orderMenuButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterMenuButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *showMenuButtonItem;


@end





@implementation SearchDeviceViewController

static UIStoryboard *mainStoryBoard;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
  
  //加载侧滑栏视图
  mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  LeftMenuViewController *leftMenuVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
  [[SlideNavigationController sharedInstance] setLeftMenu:leftMenuVC];
  RightMenuViewController *rightMenuVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RightMenuViewController"];
  [[SlideNavigationController sharedInstance] setRightMenu:rightMenuVC];
  
  //配置侧滑栏
  [self portraitSlideOffsetChanged:2];
  
  //加载上方菜单视图
  [self initNavMenuView];
  
  
  
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

#pragma mark - 事件监听
/**
 BarButtonItem
 */
- (IBAction)clickBarButtonItem:(UIBarButtonItem *)sender {
  if([sender isEqual:self.orderMenuButtonItem])
    [self toggleNavMenu:0];
  else if([sender isEqual:self.filterMenuButtonItem])
    [self toggleNavMenu:1];
  else if([sender isEqual:self.showMenuButtonItem])
    [self toggleNavMenu:2];
  else if([sender isEqual:self.leftMenuButtonItem])
    [self openMenuLeftOrRight:YES];
  else if([sender isEqual:self.rightMenuButtonItem])
    [self openMenuLeftOrRight:NO];
  
}

#pragma mark - navMenu
- (void)initNavMenuView {
  //设置视图
  CGFloat xAxis = 108.0f;
  _orderMenuVC  = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OrderMenuTableViewController"];
  [_orderMenuVC.view setFrame:CGRectMake(0, xAxis, 125, 132)];
  _filterMenuVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"FilterMenuTableViewController"];
  [_filterMenuVC.view setFrame:CGRectMake(85, xAxis, 200, 218)];
  _showMenuVC   = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ShowMenuTableViewController"];
  [_showMenuVC.view setFrame:CGRectMake(250, xAxis, 125, 132)];
  
  //设置事件
}

- (void)toggleNavMenu:(NSUInteger)type {
  UIViewController *navMenuVC;
  switch (type) {
    case 0:
      navMenuVC = _orderMenuVC;
      break;
    case 1:
      navMenuVC = _filterMenuVC;
      break;
    case 2:
      navMenuVC = _showMenuVC;
      break;
    default:
      return;
      break;
  }
  BOOL hasExist = NO;
  for (id subView in [self.view subviews]) {
    if([subView isEqual:navMenuVC.view]) {
      hasExist = YES;
      break;
    }
  }
  
  [_orderMenuVC.view  removeFromSuperview];
  [_filterMenuVC.view removeFromSuperview];
  [_showMenuVC.view   removeFromSuperview];
  
  if(hasExist) {
    [navMenuVC.view removeFromSuperview];
  } else {
    [self.view addSubview:navMenuVC.view];
  }
}

#pragma mark - RAC


#pragma mark - SlideNavigationController Delegate
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
  return NO;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
  return NO;
}

#pragma mark - SlideNavigationController Methods
/**
 打开侧滑菜单
 
 @param isLeft 左侧滑还是右侧滑
 */
- (void)openMenuLeftOrRight:(BOOL)isLeft {
  [[SlideNavigationController sharedInstance] openMenu:isLeft ? MenuLeft : MenuRight withCompletion:nil];
}

/**
 弹一下侧滑菜单
 
 @param isLeft 左侧滑还是右侧滑
 */
- (void)bounceMenu:(BOOL)isLeft
{
  [[SlideNavigationController sharedInstance] bounceMenu:isLeft ? MenuRight : MenuLeft withCompletion:nil];
}

- (void)slideOutAnimationSwitchChanged:(BOOL)isAnimation
{
  ((LeftMenuViewController *)[SlideNavigationController sharedInstance].leftMenu).slideOutAnimationEnabled = isAnimation;
}

- (void)limitPanGestureSwitchChanged:(BOOL)isLimit
{
  [SlideNavigationController sharedInstance].panGestureSideOffset = isLimit ? 50 : 0;
}

- (void)shadowSwitchSelected:(BOOL)isShadow
{
  [SlideNavigationController sharedInstance].enableShadow = isShadow;
}

- (void)enablePanGestureSelected:(UISwitch *)sender
{
  [SlideNavigationController sharedInstance].enableSwipeGesture = sender.isOn;
}


/**
 侧边栏offset
 
 */
- (void)portraitSlideOffsetChanged:(NSUInteger)type
{
  [SlideNavigationController sharedInstance].portraitSlideOffset = [self pixelsFromIndex:type];
}


/**
 侧边栏offset
 
 */
- (void)landscapeSlideOffsetChanged:(NSUInteger)type
{
  [SlideNavigationController sharedInstance].landscapeSlideOffset = [self pixelsFromIndex:type];
}





#pragma mark - Helpers -
- (NSInteger)indexFromPixels:(NSInteger)pixels
{
  if (pixels == 60)
    return 0;
  else if (pixels == 120)
    return 1;
  else
    return 2;
}

- (NSInteger)pixelsFromIndex:(NSInteger)index
{
  switch (index)
  {
    case 0:
      return 60;
      
    case 1:
      return 120;
      
    case 2:
      return 200;
      
    default:
      return 0;
  }
}




#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchedDeviceTableViewCell" forIndexPath:indexPath];

  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 90.0;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
