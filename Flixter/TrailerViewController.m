//
//  TrailerViewController.m
//  Flixter
//
//  Created by Kathy Zhong on 6/17/22.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchTrailer];
}

- (void)fetchTrailer {
    
    // 1. Create URL
    NSString *partOne = @"https://api.themoviedb.org/3/movie/";
    NSString *partTwo = [NSString stringWithFormat:@"%@", self.detailDict[@"id"]];
    NSString *partThree = @"/videos?api_key=a6792d826da47ac7ff7eea7ac959783f&language=en-US";
    NSString *tempString = [partOne stringByAppendingString:partTwo];
    NSString *fullURL = [tempString stringByAppendingString:partThree];
    
    NSURL *url = [NSURL URLWithString:fullURL];
    
    // 2. Create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3. Create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               // Create UIAlertController
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                            message:@"The internet connection appears to be offline."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
               // Create "Try Again" action + button
               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                        // Try again; if not, doing nothing will dismiss the view
                   [self fetchTrailer];
                                                                 }];
               // add the "Try Again" action to the alertController
               [alert addAction:tryAgainAction];
               
               // Show UIAlertController
               [self presentViewController:alert animated:YES completion:^{
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               // Log results
               NSLog(@"%@", dataDictionary);
               
               if (dataDictionary.count > 0)
               {
                   [self.playerView loadWithVideoId:dataDictionary[@"results"][0][@"key"]];
               }
               
           }
       }];
    // 5. Send the request we just set up
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
