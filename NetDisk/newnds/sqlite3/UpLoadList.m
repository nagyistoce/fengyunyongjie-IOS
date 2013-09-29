//
//  UpLoadList.m
//  NetDisk
//
//  Created by Yangsl on 13-9-25.
//
//

#import "UpLoadList.h"
#import "NSString+Format.h"

@implementation UpLoadList
@synthesize t_id,t_name,t_lenght,t_date,t_state,t_fileUrl,t_url_pid,t_url_name,t_file_type,user_id,file_id,upload_size,is_autoUpload,is_share,spaceId;

-(BOOL)insertUploadList
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [InsertUploadList UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        sqlite3_bind_text(statement, 1, [t_name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, t_lenght);
        sqlite3_bind_text(statement, 3, [t_date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, t_state);
        sqlite3_bind_text(statement, 5, [t_fileUrl UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [t_url_pid UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [t_url_name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 8, t_file_type);
        sqlite3_bind_text(statement, 9, [user_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10, [file_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 11, upload_size);
        sqlite3_bind_int(statement, 12, is_autoUpload);
        sqlite3_bind_int(statement, 13, is_share);
        sqlite3_bind_text(statement, 14, [spaceId UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)deleteUploadList
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [DeleteUploadList UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        sqlite3_bind_int(statement, 1, t_id);
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)deleteAutoUploadListAllAndNotUpload
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [DeleteAutoUploadListAllAndNotUpload UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)deleteMoveUploadListAllAndNotUpload
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [DeleteMoveUploadListAllAndNotUpload UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)deleteUploadListAllAndUploaded
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [DeleteUploadListAndUpload UTF8String];
        
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

-(BOOL)updateUploadList
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [UpdateUploadListForName UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        sqlite3_bind_text(statement, 1, [file_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, upload_size);
        sqlite3_bind_text(statement, 3, [t_date UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, t_state);
        sqlite3_bind_text(statement, 5, [t_name UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

//查询所有自动上传没有完成的记录
-(NSMutableArray *)selectAutoUploadListAllAndNotUpload
{
    sqlite3_stmt *statement;
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectAutoUploadListAllAndNotUpload UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        sqlite3_bind_int(statement, 1, t_id);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            UpLoadList *uploadList = [[UpLoadList alloc] init];
            uploadList.t_id = sqlite3_column_int(statement, 0);
            uploadList.t_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 1)];
            uploadList.t_lenght = sqlite3_column_int(statement, 2);
            uploadList.t_date = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 3)];
            uploadList.t_state = sqlite3_column_int(statement, 4);
            uploadList.t_fileUrl = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 5)];
            uploadList.t_url_pid = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 6)];
            uploadList.t_url_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 7)];
            uploadList.t_file_type = sqlite3_column_int(statement, 8);
            uploadList.user_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 9)];
            uploadList.file_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 10)];
            uploadList.upload_size = sqlite3_column_int(statement, 11);
            uploadList.is_autoUpload = sqlite3_column_int(statement, 12);
            uploadList.is_share = sqlite3_column_int(statement, 13);
            uploadList.spaceId = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 14)];
            [tableArray addObject:uploadList];
            [uploadList release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return [tableArray autorelease];
}

//查询所有手动上传没有完成的记录
-(NSMutableArray *)selectMoveUploadListAllAndNotUpload
{
    sqlite3_stmt *statement;
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectMoveUploadListAllAndNotUpload UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        sqlite3_bind_int(statement, 1, t_id);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            UpLoadList *uploadList = [[UpLoadList alloc] init];
            uploadList.t_id = sqlite3_column_int(statement, 0);
            uploadList.t_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 1)];
            uploadList.t_lenght = sqlite3_column_int(statement, 2);
            uploadList.t_date = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 3)];
            uploadList.t_state = sqlite3_column_int(statement, 4);
            uploadList.t_fileUrl = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 5)];
            uploadList.t_url_pid = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 6)];
            uploadList.t_url_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 7)];
            uploadList.t_file_type = sqlite3_column_int(statement, 8);
            uploadList.user_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 9)];
            uploadList.file_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 10)];
            uploadList.upload_size = sqlite3_column_int(statement, 11);
            uploadList.is_autoUpload = sqlite3_column_int(statement, 12);
            uploadList.is_share = sqlite3_column_int(statement, 13);
            uploadList.spaceId = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 14)];
            [tableArray addObject:uploadList];
            [uploadList release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return [tableArray autorelease];
}

//查询所有上传完成的历史记录
-(NSMutableArray *)selectUploadListAllAndUploaded
{
    sqlite3_stmt *statement;
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectUploadListAllAndUploaded UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            UpLoadList *uploadList = [[UpLoadList alloc] init];
            uploadList.t_id = sqlite3_column_int(statement, 0);
            uploadList.t_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 1)];
            uploadList.t_lenght = sqlite3_column_int(statement, 2);
            uploadList.t_date = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 3)];
            uploadList.t_state = sqlite3_column_int(statement, 4);
            uploadList.t_fileUrl = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 5)];
            uploadList.t_url_pid = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 6)];
            uploadList.t_url_name = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 7)];
            uploadList.t_file_type = sqlite3_column_int(statement, 8);
            uploadList.user_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 9)];
            uploadList.file_id = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 10)];
            uploadList.upload_size = sqlite3_column_int(statement, 11);
            uploadList.is_autoUpload = sqlite3_column_int(statement, 12);
            uploadList.is_share = sqlite3_column_int(statement, 13);
            uploadList.spaceId = [NSString formatNSStringForChar:(const char *)sqlite3_column_text(statement, 14)];
            [tableArray addObject:uploadList];
            [uploadList release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return [tableArray autorelease];
}


-(void)dealloc
{
    if(t_name)
    {
        [t_name release];
    }
    if(t_date)
    {
        [t_date release];
    }
    if(t_fileUrl)
    {
        [t_fileUrl release];
    }
    if(t_url_pid)
    {
        [t_url_pid release];
    }
    if(t_url_name)
    {
        [t_url_name release];
    }
    if(user_id)
    {
        [user_id release];
    }
    if(file_id)
    {
        [file_id release];
    }
    [super dealloc];
}

@end