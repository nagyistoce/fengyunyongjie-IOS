//
//  SCBFileManager.h
//  NetDisk
//
//  Created by fengyongning on 13-4-15.
//
//

#import <Foundation/Foundation.h>
typedef enum {
    kFMTypeOpenFinder,
    kFMTypeRemove,
}kFMType;
@protocol SCBFileManagerDelegate;
@interface SCBFileManager : NSObject
{
}
@property (nonatomic,assign)id<SCBFileManagerDelegate> delegate;
@property (strong,nonatomic) NSMutableData *activeData;
@property (assign,nonatomic) kFMType fm_type;
-(void)cancelAllTask;
//打开网盘/fm
-(void)openFinderWithID:(NSString *)f_id;      //无分页：所以cursor=0,offset=-1;
//新建/fm/mkdir
//重命名/fm/rename
//复制粘贴/fm/copypaste
//剪切粘贴/fm/cutpaste
//移除/fm/rm
-(void)removeFileWithIDs:(NSArray*)f_ids;
//搜索/fm/search
//打开网盘收站/fm/trash
//彻底删除/fm/trash/del
//清空回收站/fm/trash/delall
//恢复/fm/trash/resume
//恢复所有/fm/trash/resumeall
//上传状态/fm/upload/state
//上传/fm/upload
//上传校验/fm/upload/verify
//下载/fm/download
//获取文件信息/fm/getFileInfo
//查看图片文件夹/fm/pic_dir
//查看图片/fm/pic_file
//查看上传记录/fm/recent_upload
//上传/fm/upload_put
//上传校验/fm/upload/new/verify
//上传/fm/upload/new/
//上传提交/fm/upload/new/commit
//下载/fm/download/new/
@end
@protocol SCBFileManagerDelegate
-(void)openFinderSucess:(NSDictionary *)datadic;
-(void)openFinderUnsucess;
-(void)removeSucess;
-(void)removeUnsucess;
@end