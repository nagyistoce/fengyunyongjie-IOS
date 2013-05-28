//
//  YNFunctions.h
//  NetDisk
//
//  Created by fengyongning on 13-5-8.
//
//

#import <Foundation/Foundation.h>

@interface YNFunctions : NSObject
+(double)getDirectorySizeForPath:(NSString*)path;
+(NSString *)covertNumberToString:(NSDecimalNumber *)sourceNumber;
+(long long) fileSizeAtPath:(NSString*) filePath;
+(NSString *)fileType:(NSString *)fileName;
+(NSString *)getFMCachePath;    //文件缓存目录
+(NSString *)getIconCachePath;  //图标缓存
+(NSString *)getKeepCachePath;  //收藏目录
+(NSString *)getTempCachePath;  //临时缓存目录
+(NSString *)getDataCachePath;  //数据缓存目录
+(NSString *)getUserFavoriteDataPath;   //收藏数据文件路径
+(NSString *)getFileNameWithFID:(NSString *)f_id;   //根据目录ID，获取数据缓存文件名称
#pragma mark --------获取图片存档文件名
+(NSString*)picFileNameFromURL:(NSString*)URL;
#pragma mark --------换算文件容量大小
+ (NSString *)convertSize:(NSString *)sourceSize;
@end