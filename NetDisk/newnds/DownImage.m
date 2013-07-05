//
//  DownImage.m
//  NetDisk
//
//  Created by Yangsl on 13-5-6.
//
//

#import "DownImage.h"
#import "SCBoxConfig.h"
#import "SCBSession.h"
#import "MF_Base64Additions.h"
#import "YNFunctions.h"
#import "AppDelegate.h"

@implementation DownImage
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize imageUrl;
@synthesize imageViewIndex;
@synthesize fileId;
@synthesize index;
@synthesize showType;

#pragma mark
- (void)dealloc
{
    NSLog(@"下载类死亡：%i,%i",activeDownload.retainCount,imageConnection.retainCount);
    [activeDownload release];
    if(imageConnection.retainCount==1)
    {
        [imageConnection cancel];
        [imageConnection release];
    }
    [super dealloc];
}
- (void)startDownload
{
    AppDelegate *apple = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [apple setIsDownImageIsNil:FALSE];
    NSString *path = [self get_image_save_file_path:imageUrl];
    //查询本地是否已经有该图片
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    if(image)
    {
        [delegate appImageDidLoad:imageViewIndex urlImage:image index:index]; //将视图tag和地址派发给实现类
    }
    else
    {
        activeDownload = [[NSMutableData alloc] init];
        NSString *fielStirng = [NSString stringWithFormat:@"%i",self.fileId];
        if(showType == 0)
        {
//            NSURL *s_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?image_size=M",SERVER_URL,FM_DOWNLOAD_THUMB_URI]];
            NSURL *s_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,FM_DOWNLOAD_THUMB_URI]];
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:s_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:CONNECT_TIMEOUT];
            //    NSMutableString *body=[[NSMutableString alloc] init];
            //    [body appendFormat:@"f_id=%@&f_skip=%d",f_id,0];
            //    NSMutableData *myRequestData=[NSMutableData data];
            //    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            //[request setHTTPBody:myRequestData];
            [request setValue:[[SCBSession sharedSession] userId] forHTTPHeaderField:@"usr_id"];
            [request setValue:CLIENT_TAG forHTTPHeaderField:@"client_tag"];
            [request setValue:[[SCBSession sharedSession] userToken] forHTTPHeaderField:@"usr_token"];
            [request setValue:fielStirng forHTTPHeaderField:@"f_id"];
            [request setHTTPMethod:@"GET"];
            NSLog(@"%@",[request allHTTPHeaderFields]);
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        else
        {
            NSString *fielStirng = [NSString stringWithFormat:@"%i",self.fileId];
            fielStirng = [fielStirng base64String];
            NSURL *s_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?target=%@&default_pic=false",SERVER_URL,FM_DOWNLOAD_Look,fielStirng]];
            if(showType == 1)
            {
                s_url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?target=%@",SERVER_URL,FM_DOWNLOAD_Look,fielStirng]];
            }
            NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:s_url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:CONNECT_TIMEOUT];
            [request setValue:[[SCBSession sharedSession] userId] forHTTPHeaderField:@"usr_id"];
            [request setValue:CLIENT_TAG forHTTPHeaderField:@"client_tag"];
            [request setValue:[[SCBSession sharedSession] userToken] forHTTPHeaderField:@"usr_token"];
            [request setHTTPMethod:@"GET"];
            imageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
    [image release];
}

- (void)cancelDownload
{
    [imageConnection cancel];
}
#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

//下载完成后将图片写入黑盒子，
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:self.activeDownload options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"connectionDidFinishLoading:%@",connection);
    if([[diction objectForKey:@"code"] intValue] == 3)
    {
        [self startDownload];
    }
    else
    {
        NSString *documentDir = [YNFunctions getProviewCachePath];
        NSArray *array=[imageUrl componentsSeparatedByString:@"/"];
        NSString *path=[NSString stringWithFormat:@"%@/%@",documentDir,[array lastObject]];
        [activeDownload writeToFile:path atomically:YES];
        NSString *urlpath = [NSString stringWithFormat:@"%@",path];
        UIImage  *image = [UIImage imageWithContentsOfFile:urlpath];
        AppDelegate *apple = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(!apple.isDownImageIsNil)
        {
            if(delegate && [delegate respondsToSelector:@selector(appImageDidLoad:urlImage:index:)])
            {
                [delegate appImageDidLoad:imageViewIndex urlImage:image index:index]; //将视图tag和地址派发给实现类
            }
        }
        else
        {
            NSLog(@"不能添加图片了－－－－－－－－－－－－－－－－");
        }
    }
}

//这个路径下是否存在此图片
- (BOOL)image_exists_at_file_path:(NSString *)image_path
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    NSString *documentDir = [YNFunctions getProviewCachePath];
    NSArray *array=[image_path componentsSeparatedByString:@"/"];
    NSString *path=[NSString stringWithFormat:@"%@/%@",documentDir,[array lastObject]];
    return [file_manager fileExistsAtPath:path];
}


//获取图片路径
- (NSString*)get_image_save_file_path:(NSString*)image_path
{
    NSString *documentDir = [YNFunctions getProviewCachePath];
    NSArray *array=[image_path componentsSeparatedByString:@"/"];
    NSString *path=[NSString stringWithFormat:@"%@/%@",documentDir,[array lastObject]];
    return path;
}

@end
