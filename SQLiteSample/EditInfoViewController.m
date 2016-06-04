//
//  EditInfoViewController.m
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"

@interface EditInfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

- (void)loadInfoToEdit;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.noteTextView.delegate = self;
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"notedb.sql"];
    if (self.recordIDToEdit != -1) {
        [self loadInfoToEdit];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardDidHidden)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyboardDidShow:(NSNotification *)notification {
    
//    //拿到键盘尺寸
//    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
//    
//    //取得键盘的高度
//    CGFloat keyboardHeight = rect.size.height;
//    
//   // float screenHeight = [[UIScreen mainScreen] bounds].size.height;
//
//   self.noteTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0); ;
}

- (void)handleKeyboardDidHidden {
    
  //  self.noteTextView.contentInset = UIEdgeInsetsZero;;
    
}


- (void)loadInfoToEdit {

    NSString *query = [NSString stringWithFormat:@"select * from noteInfo where noteInfoID=%d", self.recordIDToEdit];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    self.noteTextView.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColummNames indexOfObject:@"noteText"]];
    
    // 将图片插入textView
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"7.jpg"];
    attachment.bounds = CGRectMake(0, -4, 200, 100);
    
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.noteTextView.attributedText];
    
    NSRange selectRange = self.noteTextView.selectedRange;
    
    [mutableStr insertAttributedString:str atIndex:selectRange.location];
    [mutableStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, mutableStr.length)];
    NSRange newRange = NSMakeRange(selectRange.location + 1, 0);
    
    self.noteTextView.attributedText = mutableStr;
    self.noteTextView.selectedRange = newRange;
    
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

- (IBAction)saveNote:(id)sender {
    
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into noteInfo values(null,'%@')", self.noteTextView.text];
        
    } else {
    
        query = [NSString stringWithFormat:@"update noteInfo set noteText='%@' where noteInfoID=%d", self.noteTextView.text,self.recordIDToEdit];
    }
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"执行成功,affectRows = %d", self.dbManager.affectedRows);
    
        [self.delegate editingInfoWasFinished];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"执行失败");
        
    }
}

@end
