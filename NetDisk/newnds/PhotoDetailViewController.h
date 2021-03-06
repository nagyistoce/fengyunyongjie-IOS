//
//  PhotoDetailViewController.h
//  NetDisk
//
//  Created by Yangsl on 13-5-6.
//
//

#import <UIKit/UIKit.h>
#import "DownImage.h"
#import "PhohoDemo.h"
#import "PhotoDetailView.h"
#import "SCBPhotoManager.h"
#import "MBProgressHUD.h"
@protocol DeleteDelegate <NSObject> //删除后，改变主窗口数据源
- (void)deleteForDeleteArray:(NSInteger)page timeLine:(NSString *)timeLineString;
@end
@interface PhotoDetailViewController : UIViewController<DownloaderDelegate,UIScrollViewDelegate,UIAlertViewDelegate,SCBPhotoDelegate,UIActionSheetDelegate>
{
    UIScrollView *scroll_View;
    float allHeight;
    NSInteger imageTag;
    NSMutableArray *allPhotoDemoArray;
    NSInteger currPageNumber;
    PhotoDetailView *OntimeView;
    
    
    int deletePage;
    
    id<DeleteDelegate> deleteDelegate;
    NSString *timeLine;
    
    NSMutableDictionary *photo_dictionary;
    MBProgressHUD *hud;
    UIButton *leftButton;
    UIButton *centerButton;
    UIButton *rightButton;
    
    BOOL isCliped;
    
    UIToolbar *topToolBar;
    UIToolbar *bottonToolBar;
}

@property(nonatomic,retain) UIScrollView *scroll_View;
@property(nonatomic,retain) id<DeleteDelegate> deleteDelegate;
@property(nonatomic,retain) NSString *timeLine;
@property(nonatomic,retain) NSMutableDictionary *photo_dictionary;
@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,assign) BOOL isCliped;
@property(nonatomic,retain) UIToolbar *topToolBar;
@property(nonatomic,retain) UIToolbar *bottonToolBar;

#pragma mark 加载所有数据
-(void)loadAllDiction:(NSArray *)allArray currtimeIdexTag:(int)indexTag;

-(void)showIndexTag:(NSInteger)indexTag;

-(void)addCenterImageView:(PhohoDemo *)demo currPage:(NSInteger)pageIndex totalCount:(NSInteger)count;



@end
