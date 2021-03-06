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
    
    [self onRefresh:self];
}

- (IBAction)addImage:(id)sender {
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select photo upload option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Use Last Taken",
                            @"Choose Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)onRefresh:(id)sender {
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString: @"soundcloud://tracks:125636702"]];
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
    cell.profileImage.layer.cornerRadius = 29;
    cell.profileImage.layer.masksToBounds = YES;
    cell.profileImage.layer.borderWidth = 0;
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/514108659660759040/PwcLTe3q_400x400.jpeg"]
                         placeholderImage:[UIImage imageNamed:@"profile"] options:SDWebImageRefreshCached];
    
    cell.userName.text = @"Emma Watson";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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

-(void)uploadPhotoToServer:(UIImage *)img {
    
    if (img != nil) {
        
        NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
        
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

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONSE %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"DID RECEIVE DATA");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Getting your response string
//    NSString *responseString = [[NSString alloc] initWithData:sel encoding:NSUTF8StringEncoding];
}



@end
