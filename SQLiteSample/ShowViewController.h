//
//  ViewController.h
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"

@interface ShowViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EditInfoViewControllerDelegate,UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *noteTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *noteSearchBar;

- (IBAction)addNewRecord:(id)sender;

@end

