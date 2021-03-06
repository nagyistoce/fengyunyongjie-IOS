//
//  DBSqlite3.m
//  NetDisk
//
//  Created by Yangsl on 13-5-27.
//
//

#import "DBSqlite3.h"
#import "YNFunctions.h"
#import "LTHPasscodeViewController.h"

@implementation DBSqlite3
@synthesize databasePath;

-(void)updateVersion
{
    self.databasePath=[YNFunctions getDBCachePath];
    self.databasePath=[self.databasePath stringByAppendingPathComponent:@"hongPanShangYe.sqlite"];
    //判断更新数据库文件
    if(![self isHaveTable:@"UploadList"])
    {
        [[LTHPasscodeViewController sharedUser] hiddenPassword];
    }
}

-(void)cleanSql
{
    self.databasePath=[YNFunctions getDBCachePath];
    self.databasePath=[self.databasePath stringByAppendingPathComponent:@"hongPanShangYe.sqlite"];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL bl = [filemgr removeItemAtPath:self.databasePath error:nil];
    DDLogCInfo(@"--------------------------------------------------\n删除所有数据库文件:%i\n--------------------------------------------------",bl);
}

-(id)init
{
    [self updateVersion];
    self.databasePath=[YNFunctions getDBCachePath];
    self.databasePath=[self.databasePath stringByAppendingPathComponent:@"hongPanShangYe.sqlite"];
    if (sqlite3_open([self.databasePath fileSystemRepresentation], &contactDB)==SQLITE_OK)
    {
        char *errMsg;
        //        if (sqlite3_exec(contactDB, [CreateTaskTable UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
        //            DDLogCError(@"errMsg:%s",errMsg);
        //        }
        //        if (sqlite3_exec(contactDB, (const char *)[CreatePhotoFileTable UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
        //            DDLogCError(@"errMsg:%s",errMsg);
        //        }
        //        if (sqlite3_exec(contactDB, (const char *)[CreateUserinfoTable UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
        //            DDLogCError(@"errMsg:%s",errMsg);
        //        }
        //        //新代码
        if (sqlite3_exec(contactDB, (const char *)[CreateUploadList UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
            DDLogCError(@"errMsg:%s",errMsg);
        }
        //        if (sqlite3_exec(contactDB, (const char *)[CreateAutoUploadList UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
        //            DDLogCError(@"errMsg:%s",errMsg);
        //        }
        //商业版新代码
        if (sqlite3_exec(contactDB, (const char *)[CreateDownList UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK) {
            DDLogCError(@"errMsg:%s",errMsg);
        }
        sqlite3_close(contactDB);
    }
    else
    {
        DDLogCError(@"创建/打开数据库失败");
    }
    
    
    return self;
}

-(BOOL)isHaveTable:(NSString *)name
{
    sqlite3_stmt *statement;
    const char *dbpath = [self.databasePath UTF8String];
    __block BOOL bl = FALSE;
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectTableIsHave UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int i = sqlite3_column_int(statement, 0);
            if(i>=1)
            {
                bl = TRUE;
                break;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)deleteUploadList:(NSString *)sqlDelete
{
    sqlite3_stmt *statement;
    __block BOOL bl = FALSE;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [sqlDelete UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        else
        {
            bl = TRUE;
        }
        DDLogCInfo(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}


@end
