//
//  ViewController.m
//  App States
//
//  Created by Zuhayeer Musa on 6/27/15.
//  Copyright (c) 2015 Zuhayeer Musa. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SVHTTPRequest.h"
#import "UserTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFNetworking.h"

@interface ViewController ()

@property (nonatomic) UIImage *selectedImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize refresh control
    if (self.refreshControl == nil) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
        refreshControl.tintColor = [UIColor darkGrayColor];
        
        [self.tableView addSubview:refreshControl];
        [self.tableView sendSubviewToBack:refreshControl];
        self.refreshControl = refreshControl;
    }
    
    self.elems = [[NSMutableArray alloc] init];
    
    [self.refreshControl beginRefreshing];
    [self onRefresh:self];
}

-(void)onRefresh:(id)sender {
    
    [[SVHTTPClient sharedClient] setBasePath:@"http://45.55.12.167:5000"];
    
    [[SVHTTPClient sharedClient] GET:@"/users/"
                          parameters:nil
                          completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                              if (error) {
                                  NSLog(@"ERROR %@", [error localizedDescription]);
                                  [self.refreshControl endRefreshing];
                              } else {
                                  if ([response isKindOfClass:[NSArray class]]) {
                                      self.elems = [response mutableCopy];
                                      NSLog(@"response %@", response);
                                      [self.tableView reloadData];
                                      [self.refreshControl endRefreshing];
                                  } else {
                                      // error not array
                                      NSError *e = nil;
                                      NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options: NSJSONReadingMutableContainers error: &e];
                                      self.elems = [jsonArray mutableCopy];
                                      NSLog(@"response %@", jsonArray);
                                      [self.tableView reloadData];
                                      [self.refreshControl endRefreshing];
                                  }
                              }
                          }];
    
//    NSArray *temp = @[@{
//                          @"profileurl":@"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xat1/v/t1.0-9/11140123_10205930822208356_8239274392144222994_n.jpg?oh=8a86407a6f1da377ee7f67e5f6c31361&oe=56318DB4",
//                          @"deeplink":@"spotify://track/7ec2JcPaqHI0XqkmS1MIHD",
//                          @"name":@"Yonatan Oren"
//                          }, @{
//                          @"profileurl":@"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xfa1/t31.0-8/10974160_790194777725137_8884707250453265044_o.jpg",
//                          @"deeplink":@"spotify://track/5IyblF777jLZj1vGHG2UD3",
//                          @"name":@"Danish Shaik"
//                          }, @{
//                          @"profileurl":@"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xpa1/t31.0-8/11046841_1615606718663113_4740997595817061651_o.jpg",
//                          @"deeplink":@"http://www.netflix.com/watch/70248289",
//                          @"name":@"Zuhayeer Musa"
//                          }, @{
//                          @"profileurl":@"https://scontent-sjc2-1.xx.fbcdn.net/hphotos-xta1/v/t1.0-9/1510644_10155541769780137_3880749382891935446_n.jpg?oh=1fba279853c1ea0b70a38259ee4f95c7&oe=561966AE",
//                          @"deeplink":@"https://www.youtube.com/watch?v=aebcJ6R0roA#t=37s",
//                          @"name":@"Norman Tasfi"
//                          }];
//    self.elems = [temp mutableCopy];
//    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
}

- (IBAction)addImage:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select photo upload option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Use Last Taken",
                            @"Choose Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserTableViewCell * cell = (UserTableViewCell *)[(UITableView *)self.tableView cellForRowAtIndexPath:indexPath];
    
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:cell.deeplink]];
                                
//      @"spotify:track:39Bi2scq80BWdgnxz2llWT#04:04"]];

    //    @"soundcloud://tracks:125636702"]];
    //      @"music://"]];
    //      @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewAlbum?i=156093464&id=156093462&s=143441"]];
    //      @"spotify:track:2QO8cnnFW6khDuAuUAySeV#19000"]];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableCell";
    
    UserTableViewCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    id obj = self.elems[indexPath.row];
    
    cell.userName.text = obj[@"track_title"];
    cell.uploadersName.text = obj[@"name"];
    NSString *capitalized = [[[obj[@"app_name"] substringToIndex:1] uppercaseString] stringByAppendingString:[obj[@"app_name"] substringFromIndex:1]];
    cell.appName.text = capitalized;
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:obj[@"profileurl"]]
                         placeholderImage:[UIImage imageNamed:@"profile"] options:SDWebImageRefreshCached];
    cell.deeplink = obj[@"deeplink"];
    
    if(indexPath.row % 4 == 1){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:0.75];
    }
    else if (indexPath.row % 4 == 2){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:0.75];
    }
    else if (indexPath.row % 4 == 3){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:0.75];
    }
//    cell.uploadersName.text = @"Danish Shaik";
//    cell.appName.text = @"Spotify";
    
    cell.opacityFilter.layer.cornerRadius = 3;
    cell.opacityFilter.layer.masksToBounds = YES;
    cell.backgroundImageView.layer.cornerRadius = 3;
    cell.backgroundImageView.layer.masksToBounds = YES;
    if ([obj[@"app_name"] isEqualToString:@"netflix"]) {
        [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://theusbport.com/wp-content/uploads/2015/06/Netflix-Family.jpg"]
                                    placeholderImage:nil options:SDWebImageRefreshCached];
    } else if ([obj[@"app_name"] isEqualToString:@"spotify"]) {
        [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.noiseporn.com/wp-content/uploads/spotifyroyalties.jpg"]
                                    placeholderImage:nil options:SDWebImageRefreshCached];
    } else {
        [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://i.telegraph.co.uk/multimedia/archive/02286/youtube_2286210b.jpg"]
                                    placeholderImage:nil options:SDWebImageRefreshCached];
    }
    cell.roundedView.layer.cornerRadius = 3;
    cell.profileImage.layer.cornerRadius = 22;
    cell.profileImage.layer.masksToBounds = YES;
    cell.profileImage.layer.borderWidth = 0;
//    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/514108659660759040/PwcLTe3q_400x400.jpeg"]
//                         placeholderImage:[UIImage imageNamed:@"profile"] options:SDWebImageRefreshCached];
    
//    cell.userName.text = @"No Church in the Wild, Kanye West";
    cell.userName.textColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.elems == nil) {
        return 0;
    }
    return [self.elems count];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.selectedImage = image;
    [self uploadPhotoToServer:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self getLastTaken];
                    break;
                case 1:
                    [self popUpImagePicker];
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)getLastTaken {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     if (nil != group) {
                                         // be sure to filter the group so you only get photos
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
                                         if (group.numberOfAssets > 0) {
                                             [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                                                     options:0
                                                                  usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                      if (nil != result) {
                                                                          ALAssetRepresentation *repr = [result defaultRepresentation];
                                                                          // this is the most recent saved photo
                                                                          UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                          self.selectedImage = img;
                                                                          [self uploadPhotoToServer:img];
                                                                          // we only need the first (most recent) photo -- stop the enumeration
                                                                          *stop = YES;
                                                                      }
                                                                  }];
                                         }
                                     }
                                     
                                     *stop = NO;
                                 } failureBlock:^(NSError *error) {
                                     NSLog(@"error: %@", error);
                                 }];
}

-(void)popUpImagePicker {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)uploadPhotoToServer:(UIImage *)img {
    
    if (img != nil) {
        
        CGSize frame = CGSizeMake(0, 0);
        frame.width = 640;
        frame.height = 1136;
        img = [self imageWithImage:img scaledToSize:frame];
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.0);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:@"http://45.55.12.167:5000/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:@"file.jpg" mimeType:@"image/jpeg"];
            
            // etc.
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}





@end
