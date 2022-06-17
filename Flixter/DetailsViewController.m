//
//  DetailsViewController.m
//  Flixter
//
//  Created by Kathy Zhong on 6/15/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailsPosterImage;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitle;
@property (weak, nonatomic) IBOutlet UIImageView *detailsPosterBackdrop;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.detailDict);
    
    // Movie synopsis
    self.detailsLabel.text = self.detailDict[@"overview"];
    
    // Movie title
    self.detailsTitle.text = self.detailDict[@"original_title"];
    
    // Load poster image
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.detailDict[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];

    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    self.detailsPosterImage.image = nil;
    [self.detailsPosterImage setImageWithURL:posterURL];
    
    // Load backdrop image
    NSString *backdropURLString = self.detailDict[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    self.detailsPosterBackdrop.image = nil;
    [self.detailsPosterBackdrop setImageWithURL:backdropURL];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSDictionary *dataToPass = self.detailDict;
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


// TODO: comment out
- (IBAction)trailerButton:(id)sender {
}
@end
