//
//  FirstViewController.m
//  hideUIBars
//
//  Created by homyu on 2015/09/13.
//  Copyright (c) 2015年 homyu. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>

// tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FirstViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [self hidesBars:NO hiddenTop:YES hiddenBottom:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - UIbars hidden

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0) {
        [self hidesBars:YES hiddenTop:YES hiddenBottom:YES];
    } else {
        [self hidesBars:NO hiddenTop:YES hiddenBottom:YES];
    }
}

- (void)hidesBars:(BOOL)hidden hiddenTop:(BOOL)hiddenTop hiddenBottom:(BOOL)hiddenBottom
{
    UITabBarController *tabBarController = self.tabBarController;
    UIEdgeInsets inset = self.tableView.contentInset;
    
    CGRect tabBarRect = tabBarController.tabBar.frame;
    CGRect topBarRect = self.navigationController.navigationBar.frame;
    CGFloat tabBerHeight = tabBarController.tabBar.frame.size.height;
    CGFloat naviBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat controllerHeight = tabBarController.view.frame.size.height;
    
    if (hidden) {
        if (hiddenTop) {
            topBarRect.origin.y = - (naviBarHeight + statusBarHeight);
            inset.top = 0;
        }
        if (hiddenBottom) {
            tabBarRect.origin.y = controllerHeight;
            inset.bottom = 0;
        }
    } else {
        topBarRect.origin.y = statusBarHeight;
        inset.top = naviBarHeight + statusBarHeight;
        tabBarRect.origin.y = controllerHeight - tabBerHeight;
        inset.bottom = tabBerHeight;
    }
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        self.tableView.contentInset = inset;
        self.tableView.scrollIndicatorInsets = inset;
        tabBarController.tabBar.frame = tabBarRect;
        self.navigationController.navigationBar.frame = topBarRect;
    }];
}

#pragma mark - tableView Delegate/Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"sample %ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:NSStringFromClass([SecondViewController class]) sender:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:NSStringFromClass([SecondViewController class])]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        SecondViewController *controller = segue.destinationViewController;
        controller.navigationItem.title = [NSString stringWithFormat:@"sample %ld",indexPath.row];
    }
}

@end
