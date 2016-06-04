//
//  DBManager.m
//  SQLiteSample
//
//  Created by 周开伟 on 16/5/28.
//  Copyright © 2016年 zweite. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;


- (void)copyDatabaseIntoDocumentsDirectory;

- (void)runQuery:(const char *)query isQueryExcutable:(BOOL)queryExecutable;
@end

@implementation DBManager

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {

    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = dbFilename;
        
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}
- (void)copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
       
        NSError *error;
        
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)runQuery:(const char *)query isQueryExcutable:(BOOL)queryExecutable {

    sqlite3 *sqlite3Database;
    
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // 初始化arrResults
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    //初始化数组arrColumnNames
    if (self.arrColummNames != nil) {
        [self.arrColummNames removeAllObjects];
        self.arrColummNames = nil;
    }
    self.arrColummNames = [[NSMutableArray alloc] init];
    
    // 打开数据库
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK) {
        
        sqlite3_stmt *compiledSatatement;
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledSatatement, NULL);

        if (prepareStatementResult == SQLITE_OK) {
            if (!queryExecutable) {
             
                NSMutableArray *arrDataRow;
                
                while (sqlite3_step(compiledSatatement) == SQLITE_ROW) {
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    int totalColumns = sqlite3_column_count(compiledSatatement);
                    
                    for (int i = 0; i < totalColumns; i++) {
                       
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledSatatement, i);
                        
                        if (dbDataAsChars != NULL) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        if (self.arrColummNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledSatatement,i);
                            [self.arrColummNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // 执行查询
                
                NSInteger executeQueryResults = sqlite3_step(compiledSatatement);
                if (executeQueryResults == SQLITE_DONE) {
                    
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    self.lastInsertRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    NSLog(@"DB Error: %s",sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            NSLog(@"%s",sqlite3_errmsg(sqlite3Database));
        }
        sqlite3_finalize(compiledSatatement);
    }
    sqlite3_close(sqlite3Database);
}



- (NSArray *)loadDataFromDB:(NSString *)query {
    
    [self runQuery:[query UTF8String] isQueryExcutable:NO];
    
    return (NSArray *)self.arrResults;
}

- (void)executeQuery:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExcutable:YES];
}


@end
