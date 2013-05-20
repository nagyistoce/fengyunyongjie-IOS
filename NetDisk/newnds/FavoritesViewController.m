//
//  FavoritesViewController.m
//  NetDisk
//
//  Created by fengyongning on 13-5-16.
//
//

#import "FavoritesViewController.h"
#import "FavoritesData.h"
#import "PhohoDemo.h"
#import "PhotoDetailViewController.h"
@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count=[[FavoritesData sharedFavoritesData] count];
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=@"fane";
    NSDictionary *dic=[[[[FavoritesData sharedFavoritesData] favoriteDic] allValues] objectAtIndex:indexPath.row];
    NSString *name= [dic objectForKey:@"f_name"];
    NSString *f_modify=[dic objectForKey:@"f_modify"];
    NSString *t_fl = [[dic objectForKey:@"f_mime"] lowercaseString];
    cell.textLabel.text=name;
    cell.detailTextLabel.text=f_modify;
    if ([t_fl isEqualToString:@"directory"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_Folder.png"];
    }else if ([t_fl isEqualToString:@"png"]||
              [t_fl isEqualToString:@"jpg"]||
              [t_fl isEqualToString:@"jpeg"]||
              [t_fl isEqualToString:@"bmp"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_pic.png"];
        
    }else if ([t_fl isEqualToString:@"doc"]||
              [t_fl isEqualToString:@"docx"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_doc.png"];
    }else if ([t_fl isEqualToString:@"mp3"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_music.png"];
    }else if ([t_fl isEqualToString:@"mov"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_movie.png"];
    }else if ([t_fl isEqualToString:@"ppt"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_ppt.png"];
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_unkown.png"];
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *listArray=[[FavoritesData sharedFavoritesData].favoriteDic allValues];
        NSDictionary *dic=[listArray objectAtIndex:indexPath.row];
        NSString *f_id=[dic objectForKey:@"f_id"];
        [[FavoritesData sharedFavoritesData] removeObjectForKey:f_id];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listArray=[[FavoritesData sharedFavoritesData].favoriteDic allValues];
    NSDictionary *dic=[listArray objectAtIndex:indexPath.row];
    NSString *f_mime=[[dic objectForKey:@"f_mime"] lowercaseString];
    if ([f_mime isEqualToString:@"png"]||
        [f_mime isEqualToString:@"jpg"]||
        [f_mime isEqualToString:@"jpeg"]||
        [f_mime isEqualToString:@"bmp"]) {
        NSMutableArray *array=[NSMutableArray array];
        int index=0;
        for (int i=0;i<listArray.count;i++) {
            NSDictionary *dict=[listArray objectAtIndex:i];
            NSString *f_mime=[[dict objectForKey:@"f_mime"] lowercaseString];
            if ([f_mime isEqualToString:@"png"]||
                [f_mime isEqualToString:@"jpg"]||
                [f_mime isEqualToString:@"jpeg"]||
                [f_mime isEqualToString:@"bmp"]) {
                PhohoDemo *photo_demo=[[PhohoDemo alloc] init];
                [photo_demo setF_mime:[dict objectForKey:@"f_mime"]];
                [photo_demo setF_size:[[dict objectForKey:@"f_size"] intValue]];
                [photo_demo setF_name:[dict objectForKey:@"f_name"]];
                [photo_demo setF_pid:[[dict objectForKey:@"f_pid"] intValue]];
                if([[dict objectForKey:@"img_create"] isKindOfClass:[NSString class]])
                {
                    [photo_demo setImg_create:[dict objectForKey:@"img_create"]];
                }
                
                [photo_demo setF_create:[dict objectForKey:@"f_create"]];
                [photo_demo setF_id:[[dict objectForKey:@"f_id"] intValue]];
                [photo_demo setF_mime:[dict objectForKey:@"f_modify"]];
                [photo_demo setCompressaddr:[dict objectForKey:@"compressaddr"]];
                [photo_demo setF_ownerid:[[dict objectForKey:@"f_ownerid"] intValue]];
                [array addObject:photo_demo];
                if (i==indexPath.row) {
                    index=array.count-1;
                }
                [photo_demo release];
            }
        }
        PhotoDetailViewController *photoDetalViewController = [[PhotoDetailViewController alloc] init];
        photoDetalViewController.deleteDelegate = self;
        [self presentViewController:photoDetalViewController animated:YES completion:^{
            //[photoDetalViewController setTimeLine:image_button.timeLine];
            [photoDetalViewController loadAllDiction:array currtimeIdexTag:index];
            [photoDetalViewController release];
        }];
        
    }

}

@end
