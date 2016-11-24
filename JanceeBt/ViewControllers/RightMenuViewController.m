//
//  RightMenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/26/14.
//  Copyright (c) 2014 Aryan Ghassemi. All rights reserved.
//

#import "RightMenuViewController.h"

@implementation RightMenuViewController

#pragma mark - UIViewController Methods -

- (void)viewDidLoad
{
	[super viewDidLoad];
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
  UILabel *label = [[UILabel alloc] init];
  label.frame = CGRectMake(self.tableView.frame.size.width - 180, 20, 180, 20);
  label.textAlignment = NSTextAlignmentCenter;
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor blackColor];
  label.shadowColor = [UIColor grayColor];
  label.font = [UIFont systemFontOfSize:19];
  label.text = NSLocalizedString(@"已连接设备列表", nil);
  
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  [view addSubview:label];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightMenuCell2"];
	
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"None";
			break;
			
		case 1:
			cell.textLabel.text = @"Slide";
			break;
			
		case 2:
			cell.textLabel.text = @"Fade";
			break;
			
		case 3:
			cell.textLabel.text = @"Slide And Fade";
			break;
			
		case 4:
			cell.textLabel.text = @"Scale";
			break;
			
		case 5:
			cell.textLabel.text = @"Scale And Fade";
			break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id <SlideNavigationContorllerAnimator> revealAnimator;
	CGFloat animationDuration = 0;
	
	switch (indexPath.row)
	{
		case 2:
			revealAnimator = [[SlideNavigationContorllerAnimatorFade alloc] init];
			animationDuration = .18;
			break;
		default:
			return;
	}
	
	[[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
		[SlideNavigationController sharedInstance].menuRevealAnimationDuration = animationDuration;
		[SlideNavigationController sharedInstance].menuRevealAnimator = revealAnimator;
	}];
}

@end
