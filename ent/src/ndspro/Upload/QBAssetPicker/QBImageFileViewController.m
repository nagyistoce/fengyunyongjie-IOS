//
//  QBImageFileViewController.m
//  NetDisk
//
//  Created by Yangsl on 13-7-25.
//
//

//#define TabBarHeight 60
#define QBY 0
#define TableViewHeight (self.view.frame.size.height-TabBarHeight-44-QBY)
#define ChangeTabWidth 120
#define RightButtonBoderWidth 0
//#define hilighted_color [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:94.0/255.0 alpha:1.0]
#define BottonViewHeight self.view.frame.size.height-TabBarHeight+QBY

#import "QBImageFileViewController.h"
#import "FileItemTableCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SCBSession.h"

@interface QBImageFileViewController ()

@end

@implementation QBImageFileViewController
@synthesize table_view;
@synthesize fileArray;
@synthesize qbDelegate;
@synthesize f_name;
@synthesize f_id;
@synthesize isChangeMove;
@synthesize space_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//<ios 6.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

//>ios 6.0
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *app_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(app_delegate.myTabBarController.selectedIndex==0)
//    {
//        space_id = [[SCBSession sharedSession] spaceID];
//    }
//    else if(app_delegate.myTabBarController.selectedIndex==1 && !space_id)
//    {
//        space_id = [[SCBSession sharedSession] homeID];
//    }
    
    NSLog(@"space_id:%@",space_id);
    
    //添加头部试图
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, QBY, 320, 44)];
    UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [images setImage:[UIImage imageNamed:@"Bk_Title.png"]];
    [topView addSubview:images];
    isNeedBackButton = YES;
    //把色值转换成图片
    CGRect rect_image = CGRectMake(0, 0, ChangeTabWidth, 44);
    UIGraphicsBeginImageContext(rect_image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [hilighted_color CGColor]);
    CGContextFillRect(context, rect_image);
    UIImage * imge = [[UIImage alloc] init];
    imge = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //返回按钮
    if(isNeedBackButton)
    {
        UIImage *back_image = [UIImage imageNamed:@"Bt_Back.png"];
        UIButton *back_button = [[UIButton alloc] initWithFrame:CGRectMake(RightButtonBoderWidth, (44-back_image.size.height/2)/2, back_image.size.width/2, back_image.size.height/2)];
        [back_button addTarget:self action:@selector(clicked_back) forControlEvents:UIControlEventTouchUpInside];
        [back_button setBackgroundImage:imge forState:UIControlStateHighlighted];
        [back_button setImage:back_image forState:UIControlStateNormal];
        [topView addSubview:back_button];
    }
    
    
    //选项卡栏目
    UIButton *phoot_button = [[UIButton alloc] init];
    [phoot_button setTag:23];
    [phoot_button setFrame:CGRectMake((320-ChangeTabWidth)/2, 0, ChangeTabWidth, 44)];
    [phoot_button setTitle:f_name forState:UIControlStateNormal];
    [phoot_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [phoot_button addTarget:self action:@selector(clicked_uploadState:) forControlEvents:UIControlEventTouchDown];
    //    [phoot_button setBackgroundImage:imge forState:UIControlStateHighlighted];
    [topView addSubview:phoot_button];
    
    
    //更多按钮
    UIButton *more_button = [[UIButton alloc] initWithFrame:CGRectMake(320-RightButtonBoderWidth-40, 0, 40, 44)];
    [more_button setTitle:@"全选" forState:UIControlStateNormal];
    [more_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [more_button addTarget:self action:@selector(clicked_more:) forControlEvents:UIControlEventTouchDown];
    [more_button setBackgroundImage:imge forState:UIControlStateHighlighted];
    [more_button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [topView addSubview:more_button];
    [more_button setHidden:YES];
    [self.view addSubview:topView];
    
    CGRect change_rect = CGRectMake(0, BottonViewHeight-26, 320, 24);
    change_myFile_button = [[UIButton alloc] initWithFrame:change_rect];
    [change_myFile_button setTitle:@"我的文件" forState:UIControlStateNormal];
    [change_myFile_button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    change_myFile_button.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    //添加底部视图
    NSLog(@"BottonViewHeight:%f",BottonViewHeight);
    bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, BottonViewHeight, 320, 60)];
    UIImageView *botton_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bottonView.frame.size.width, bottonView.frame.size.height)];
    [botton_image setImage:[UIImage imageNamed:@"Bk_Nav.png"]];
    [bottonView addSubview:botton_image];
    
    UIButton *upload_button = [[UIButton alloc] initWithFrame:CGRectMake((320/2-29)/2, (TabBarHeight-29)/2, 29, 29)];
    [upload_button setBackgroundImage:[UIImage imageNamed:@"Bt_UploadOk.png"] forState:UIControlStateNormal];
    [upload_button setBackgroundImage:[UIImage imageNamed:@"Bt_UploadOkCh.png"] forState:UIControlStateHighlighted];
    [upload_button addTarget:self action:@selector(clicked_changeMyFile:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:upload_button];
    
    UIButton *upload_back_button = [[UIButton alloc] initWithFrame:CGRectMake(320/2+(320/2-29)/2, (TabBarHeight-29)/2, 29, 29)];
    [upload_back_button setBackgroundImage:[UIImage imageNamed:@"Bt_UploadCancle.png"] forState:UIControlStateNormal];
    [upload_back_button setBackgroundImage:[UIImage imageNamed:@"Bt_UploadCancleCh.png"] forState:UIControlStateHighlighted];
    [upload_back_button addTarget:self action:@selector(clicked_uploadStop:) forControlEvents:UIControlEventTouchUpInside];
    [bottonView addSubview:upload_back_button];
    
    [self.view addSubview:bottonView];
    
    CGRect rect = CGRectMake(0, 44+QBY, 320, TableViewHeight);
    table_view = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    table_view.dataSource = self;
    table_view.delegate = self;
    [self.view addSubview:table_view];
    
    //请求所有的数据文件
}

-(void)clicked_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clicked_uploadState:(id)sender
{
    
}

-(void)clicked_more:(id)sender
{
    
}

-(void)clicked_changeMyFile:(id)sender
{
    [self.qbDelegate uploadFileder:f_name];
    [self.qbDelegate uploadFiledId:f_id];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)newFold:(NSDictionary *)dictionary
{
    
}

-(void)openFile:(NSDictionary *)dictionary
{
    NSLog(@"dictionary:%@",dictionary);
    if(self.fileArray)
    {
        [self.fileArray removeAllObjects];
    }
    else
    {
        self.fileArray = [[NSMutableArray alloc] init];
    }
    for(NSDictionary *diction in [dictionary objectForKey:@"files"])
    {
        NSString *f_mime = [diction objectForKey:@"f_mime"];
        NSLog(@"f_mime:%@",f_mime);
        if([f_mime isEqualToString:@"directory"])
        {
            [self.fileArray addObject:diction];
        }
    }
    [table_view reloadData];
}

-(void)clicked_uploadStop:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -------- TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QBImageFileCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FileItemTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([self.fileArray count]>0) {
        NSDictionary *this=(NSDictionary *)[self.fileArray objectAtIndex:indexPath.row];
        NSString *name= [this objectForKey:@"f_name"];
        NSString *f_modify=[this objectForKey:@"f_modify"];
        cell.textLabel.text=name;
        cell.detailTextLabel.text=f_modify;
        cell.imageView.image = [UIImage imageNamed:@"Ico_FolderF.png"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        QBImageFileViewController *qbImage_fileView = [[QBImageFileViewController alloc] init];
        NSDictionary *this=(NSDictionary *)[self.fileArray objectAtIndex:indexPath.row];
        qbImage_fileView.f_id = [this objectForKey:@"f_id"];
        qbImage_fileView.f_name = [this objectForKey:@"f_name"];
        [qbImage_fileView setQbDelegate:self];
        [self.navigationController pushViewController:qbImage_fileView animated:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadFileder:(NSString *)deviceName
{
    [self.qbDelegate uploadFileder:deviceName];
}

-(void)uploadFiledId:(NSString *)f_id_
{
    [self.qbDelegate uploadFiledId:f_id_];
}

@end


@implementation FileDeviceName
@synthesize deviceName,f_id;

@end