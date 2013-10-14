//
//  UploadViewCell.m
//  NetDisk
//
//  Created by Yangsl on 13-7-26.
//
//

#import "UploadViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "YNFunctions.h"

@implementation UploadViewCell
@synthesize button_dele_button,imageView,contentView,label_name;
@synthesize delegate,button_start_button,jinDuView,size_label,sudu_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect image_rect = CGRectMake(5, 5, 40, 40);
        self.imageView = [[UIImageView alloc] initWithFrame:image_rect];
        [self addSubview:self.imageView];
        
        CGRect label_rect = CGRectMake(60, 5, 150, 20);
        self.label_name = [[UILabel alloc] initWithFrame:label_rect];
        [self.label_name setTextColor:[UIColor blackColor]];
        [self.label_name setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.label_name];
        
        CGRect progress_rect = CGRectMake(60, 30, 150, 3);
        self.jinDuView = [[CustomJinDu alloc] initWithFrame:progress_rect];
        [self addSubview:self.jinDuView];
        
        CGRect sizeRect = CGRectMake(200, 6, 100, 15);
        self.size_label = [[UILabel alloc] initWithFrame:sizeRect];
        [self.size_label setTextColor:[UIColor blackColor]];
        [self.size_label setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.size_label];
        CGRect suduRect = CGRectMake(200, 22, 100, 15);
        self.sudu_label = [[UILabel alloc] initWithFrame:suduRect];
        [self.sudu_label setTextColor:[UIColor colorWithRed:0.0/255.0 green:160.0/255.0 blue:230.0/255.0 alpha:1]];
        [self.sudu_label setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.sudu_label];
        
        CGRect button_rect = CGRectMake(270, 0, 50, 50);
        self.button_dele_button = [[UIButton alloc] initWithFrame:button_rect];
        [self.button_dele_button setBackgroundImage:[UIImage imageNamed:@"Bt_Cancle.png"] forState:UIControlStateNormal];
        [self.button_dele_button addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button_dele_button];
        
        CGRect start_rect = CGRectMake(270, 15, 40, 30);
        self.button_start_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.button_start_button setFrame:start_rect];
        [self.button_start_button setBackgroundColor:[UIColor clearColor]];
        [self.button_start_button setTitle:@"暂停" forState:UIControlStateNormal];
        [self.button_start_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button_start_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.button_start_button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.button_start_button];
        [self.button_start_button setHidden:YES];
    }
    return self;
}

-(void)start
{
    AppDelegate *app_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([self.button_start_button.titleLabel.text isEqualToString:@"暂停"])
    {
        NSLog(@"self.button_start_button.titleLabel.text 0");
        [self.button_start_button setTitle:@"继续" forState:UIControlStateNormal];
        //        [app_delegate.autoUpload stopUpload];
    }
    else
    {
        NSLog(@"self.button_start_button.titleLabel.text 1");
        [self.button_start_button setTitle:@"暂停" forState:UIControlStateNormal];
        //        [app_delegate.autoUpload goOnUpload];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setUploadDemo:(UpLoadList *)list
{
    upload_list = list;
    [self.size_label setText:[YNFunctions convertSize:[NSString stringWithFormat:@"%i",list.t_lenght]]];
    [self.sudu_label setText:[NSString stringWithFormat:@"%@/s",[YNFunctions convertSize:[NSString stringWithFormat:@"%i",list.sudu]]]];
    if(list.sudu==-1)
    {
        [self.sudu_label setHidden:YES];
    }
    else
    {
        [self.sudu_label setHidden:NO];
    }
    if(list.t_state == 1)
    {
        [self.sudu_label setHidden:YES];
        [self.jinDuView showDate:list.t_date];
    }
    else if(list.t_state == 0)
    {
        float f = (float)list.upload_size / (float)list.t_lenght;
        [self.jinDuView setCurrFloat:f];
    }
    else if(list.t_state == 2)
    {
        [self.jinDuView showText:@"暂停"];
    }
    else if(list.t_state == 3)
    {
        [self.jinDuView showText:@"等待WiFi"];
    }
    if(![self.label_name.text isEqualToString:list.t_name])
    {
        ALAssetsLibrary *libary = [[ALAssetsLibrary alloc] init];
        [libary assetForURL:[NSURL URLWithString:list.t_fileUrl] resultBlock:^(ALAsset *result){
            UIImage *imageV = [UIImage imageWithCGImage:[result thumbnail]];
            if(imageV.size.width>=imageV.size.height)
            {
                if(imageV.size.height<=88)
                {
                    CGRect imageRect = CGRectMake((imageV.size.width-imageV.size.height)/2, 0, imageV.size.height, imageV.size.height);
                    imageV = [self imageFromImage:imageV inRect:imageRect];
                    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageV waitUntilDone:YES];
                }
                else
                {
                    CGSize newImageSize;
                    newImageSize.height = 88;
                    newImageSize.width = 88*imageV.size.width/imageV.size.height;
                    UIImage *imageS = [self scaleFromImage:imageV toSize:newImageSize];
                    CGRect imageRect = CGRectMake((newImageSize.width-88)/2, 0, 88, 88);
                    imageS = [self imageFromImage:imageS inRect:imageRect];
                    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageS waitUntilDone:YES];
                }
            }
            else if(imageV.size.width<=imageV.size.height)
            {
                if(imageV.size.width<=88)
                {
                    CGRect imageRect = CGRectMake(0, (imageV.size.height-imageV.size.width)/2, imageV.size.width, imageV.size.width);
                    imageV = [self imageFromImage:imageV inRect:imageRect];
                    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageV waitUntilDone:YES];
                }
                else
                {
                    CGSize newImageSize;
                    newImageSize.width = 88;
                    newImageSize.height = 88*imageV.size.height/imageV.size.width;
                    UIImage *imageS = [self scaleFromImage:imageV toSize:newImageSize];
                    CGRect imageRect = CGRectMake(0, (newImageSize.height-88)/2, 88, 88);
                    imageS = [self imageFromImage:imageS inRect:imageRect];
                    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageS waitUntilDone:YES];
                }
            }
        } failureBlock:^(NSError *error){}];
        
    }
    [self.label_name setText:list.t_name];
}

-(void)setDownDemo:(DownList *)list
{
    [self.size_label setText:[YNFunctions convertSize:[NSString stringWithFormat:@"%i",list.d_downSize]]];
    [self.sudu_label setText:[NSString stringWithFormat:@"%@/s",[YNFunctions convertSize:[NSString stringWithFormat:@"%i",list.sudu]]]];
    if(list.sudu==-1)
    {
        [self.sudu_label setHidden:YES];
    }
    else
    {
        [self.sudu_label setHidden:NO];
    }
    down_list = list;
    if(list.d_state == 1)
    {
        [self.sudu_label setHidden:YES];
        [self.jinDuView showDate:list.d_datetime];
    }
    else if(list.d_state == 0)
    {
        float f = (float)list.curr_size / (float)list.d_downSize;
        [self.jinDuView setCurrFloat:f];
    }
    else if(list.d_state == 2)
    {
        [self.jinDuView showText:@"暂停"];
    }
    else if(list.d_state == 3)
    {
        [self.jinDuView showText:@"等待WiFi"];
    }
    if(![self.label_name.text isEqualToString:list.d_name])
    {
        UIImage *imageV;
        if([list.d_thumbUrl length]==0)
        {
            imageV = [UIImage imageNamed:@"file_other@2x.png"];
        }
        else
        {
            NSString *thumbUrl = [self getThumbPath:list.d_thumbUrl];
            imageV = [UIImage imageWithContentsOfFile:thumbUrl];
        }
        if(imageV.size.width>=imageV.size.height)
        {
            if(imageV.size.height<=88)
            {
                CGRect imageRect = CGRectMake((imageV.size.width-imageV.size.height)/2, 0, imageV.size.height, imageV.size.height);
                imageV = [self imageFromImage:imageV inRect:imageRect];
                [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageV waitUntilDone:YES];
            }
            else
            {
                CGSize newImageSize;
                newImageSize.height = 88;
                newImageSize.width = 88*imageV.size.width/imageV.size.height;
                UIImage *imageS = [self scaleFromImage:imageV toSize:newImageSize];
                CGRect imageRect = CGRectMake((newImageSize.width-88)/2, 0, 88, 88);
                imageS = [self imageFromImage:imageS inRect:imageRect];
                [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageS waitUntilDone:YES];
            }
        }
        else if(imageV.size.width<=imageV.size.height)
        {
            if(imageV.size.width<=88)
            {
                CGRect imageRect = CGRectMake(0, (imageV.size.height-imageV.size.width)/2, imageV.size.width, imageV.size.width);
                imageV = [self imageFromImage:imageV inRect:imageRect];
                [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageV waitUntilDone:YES];
            }
            else
            {
                CGSize newImageSize;
                newImageSize.width = 88;
                newImageSize.height = 88*imageV.size.height/imageV.size.width;
                UIImage *imageS = [self scaleFromImage:imageV toSize:newImageSize];
                CGRect imageRect = CGRectMake(0, (newImageSize.height-88)/2, 88, 88);
                imageS = [self imageFromImage:imageS inRect:imageRect];
                [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:imageS waitUntilDone:YES];
            }
        }
        
    }
    [self.label_name setText:list.d_name];
}

-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
	CGImageRef sourceImageRef = [image CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
	return newImage;
}

-(NSString *)getThumbPath:(NSString *)name
{
    NSString *documentDir = [YNFunctions getIconCachePath];
    NSArray *array=[name componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@/%@",documentDir,[array lastObject]];
}

-(NSString *)getFilePath:(NSString *)name
{
    NSString *documentDir = [YNFunctions getProviewCachePath];
    NSArray *array=[name componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"%@/%@",documentDir,[array lastObject]];
}

-(void)showTopBar
{
    
}

-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)deleteSelf
{
    if(upload_list)
    {
        [delegate deletCell:upload_list];
    }
    else if(down_list)
    {
        [delegate deletCell:down_list];
    }
    
}

@end
