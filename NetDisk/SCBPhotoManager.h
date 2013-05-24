//
//  SCBPhotoManager.h
//  NetDisk
//
//  Created by fengyongning on 13-4-15.
//
//

#define timeLine1 @"今天"
#define timeLine2 @"昨天"
#define timeLine3 @"本周"
#define timeLine4 @"上一周"
#define timeLine5 @"本月"
#define timeLine6 @"上一月"
#define timeLine7 @"本年"

#import <Foundation/Foundation.h>

@protocol SCBPhotoDelegate <NSObject>

-(void)getPhotoTiimeLine:(NSDictionary *)dictionary;

-(void)getPhotoGeneral:(NSDictionary *)dictionary photoDictioin:(NSMutableDictionary *)photoDic;

-(void)getPhotoDetail:(NSDictionary *)dictionary;

-(void)requstDelete:(NSDictionary *)dictionary;

@end

@protocol NewFoldDelegate <NSObject>

-(void)newFold:(NSDictionary *)dictionary;

-(void)openFile:(NSDictionary *)dictionary;

@end

@interface SCBPhotoManager : NSObject
{
    id<SCBPhotoDelegate> photoDelegate;
    id<NewFoldDelegate> newFoldDelegate;
    NSString *url_string;
    int timeLineTotalNumber;
    int timeLineNowNumber;
    NSArray *timeLineAllArray;
    NSMutableDictionary *timeDictionary;
    NSMutableDictionary *photoDictionary;
    NSMutableData *matableData;
    NSMutableArray *allKeysArray;
}

@property(nonatomic,retain) id<SCBPhotoDelegate> photoDelegate;
@property(nonatomic,retain) NSMutableData *matableData;
@property(nonatomic,retain) id<NewFoldDelegate> newFoldDelegate;

//获取时间分组/photo/timeline
-(void)getPhotoTimeLine;
//获取所有时间轴上的照片信息
-(void)getAllPhotoGeneral:(NSArray *)timeLineArray;
//获取按年或月查询的概要照片/photo/general
-(void)getPhotoGeneral;
//获取按日查询的照片/photo/detail
//获取最新标签/photo/tag/recent
//获取指定文件相关标签/photo/tag/file_tags
//根据标签集查询文件列表/photo/tag/tag_files
//给指定文件集标注指定的标签集/photo/tag/file_add
//给指定文件集删除指定文件标签集/photo/tag/file_del
//创建标签/photo/tag/create
//删除标签/photo/tag/del

//删除文件
//得到月份天数
-(int)theDaysInYear:(int)year inMonth:(int)month;
#pragma mark 获取当月过了多少天
-(int)getNowMonthToManyDay;
#pragma mark 获取本年过了多少天
-(int)getNowYearToManyDay;
#pragma mark 请求删除文件
-(void)requestDeletePhoto:(NSArray *)deleteId;
#pragma mark 新建文件夹
-(void)requestNewFold:(NSString *)name FID:(int)f_id;
#pragma mark 打开文件目录
-(void)openFinderWithID:(NSString *)f_id;

@end
