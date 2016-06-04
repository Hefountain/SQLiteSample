//
//  DBManager.h
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong)NSMutableArray *arrColummNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertRowID;

//  确定数据库文件是否存在，不存在，则再copy一份
- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

- (NSArray *)loadDataFromDB:(NSString *)query;

- (void)executeQuery:(NSString *)query;

@end

