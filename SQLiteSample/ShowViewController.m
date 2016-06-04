//
//  ViewController.m
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import "ShowViewController.h"
#import "DBManager.h"

@interface ShowViewController ()

@property (nonatomic, strong)DBManager *dbManager;

@property (nonatomic, strong)NSArray *arrNoteInfo;

@property (nonatomic)int recordIDToEdit;


- (void)loadData;

@end


@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.noteTableView.delegate = self;
    self.noteTableView.dataSource = self;
    self.noteSearchBar.delegate = self;
    
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"notedb.sql"];
    [self loadData];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    EditInfoViewController *editInfoCtrl = [segue destinationViewController];
    editInfoCtrl.delegate = self;
    editInfoCtrl.recordIDToEdit = self.recordIDToEdit;
    
}

- (void)loadData {

    NSString *query = @"select * from noteInfo";
    
    if (self.arrNoteInfo != nil) {
        self.arrNoteInfo = nil;
    }
    self.arrNoteInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.noteTableView reloadData];
    
}

- (IBAction)addNewRecord:(id)sender {

    // 设置recordIDToEdit为-1，标识下：是要新建一个新的note，而不是编辑一个已存在的note
    self.recordIDToEdit = -1;
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];

}

#pragma mark -  UITableView method implementation 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrNoteInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    NSInteger indexOfNote = [self.dbManager.arrColummNames indexOfObject:@"noteText"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[self.arrNoteInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfNote]];
    
    NSLog(@"%@",_arrNoteInfo);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.recordIDToEdit = [[[self.arrNoteInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
    
}

// 修改默认的delete为中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self.arrNoteInfo removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self.arrayTest exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
//        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    topRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//      
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    return @[deleteRowAction,topRowAction,moreRowAction];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        int recordIDToDelete = [[[self.arrNoteInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        NSString *query = [NSString stringWithFormat:@"delete from noteInfo where noteInfoID=%d",recordIDToDelete];
        
        [self.dbManager executeQuery:query];
        
        [self loadData];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.noteSearchBar resignFirstResponder];
    
}


#pragma mark -UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if ([searchText length] > 0) {
        [self doSearch:searchText];
    } else {
        NSString *query = @"select * from noteInfo";
        self.arrNoteInfo = [self.dbManager loadDataFromDB:query];
        [self.noteTableView reloadData];
    }
    
//    [searchBar resignFirstResponder];
}

- (void)doSearch:(NSString *)searchStr {
    
    NSString *query = [NSString stringWithFormat:@"select * from noteInfo where noteText like '%%%@%%'",searchStr];
    
    self.arrNoteInfo = [self.dbManager loadDataFromDB:query];
    
    [self.noteTableView reloadData];

}

#pragma mark - EditInfoViewControllerDelegate
- (void)editingInfoWasFinished {
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
