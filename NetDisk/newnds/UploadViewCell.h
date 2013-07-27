//
//  UploadViewCell.h
//  NetDisk
//
//  Created by Yangsl on 13-7-26.
//
//

#import <UIKit/UIKit.h>

//引用类
#import "TaskDemo.h"
@protocol UploadViewCellDelegate <NSObject>

-(void)deletCell:(id)uploadCell;

@end

@interface UploadViewCell : UITableViewCell
{
    UIImageView *imageView;
    UILabel *label_name;
    UIProgressView *progressView;
    UIButton *button_dele_button;
    TaskDemo *demo;
    
    id<UploadViewCellDelegate> delegate;
}

@property(nonatomic,retain) UIImageView *imageView;
@property(nonatomic,retain) UILabel *label_name;
@property(nonatomic,retain) UIProgressView *progressView;
@property(nonatomic,retain) UIButton *button_dele_button;
@property(nonatomic,retain) TaskDemo *demo;

@property(nonatomic,retain) id<UploadViewCellDelegate> delegate;

-(void)setUploadDemo:(TaskDemo *)demo_;

@end

