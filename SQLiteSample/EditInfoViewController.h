//
//  EditInfoViewController.h
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate <NSObject>

- (void)editingInfoWasFinished;

@end

@interface EditInfoViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<EditInfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (nonatomic) int recordIDToEdit;

- (IBAction)saveNote:(id)sender;

@end
