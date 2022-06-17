//
//  MovieViewController.m
//  Flixter
//
//  Created by Kathy Zhong on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
    // From the video in the hint: set data source and delegate to the view controller
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Implement search bars
    self.searchBar.delegate = self;
    
    // Call fetchMovies method
    [self fetchMovies];
    
    // Implement refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Customize navigation bar
    // Change back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back to Now Playing" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)fetchMovies {
    
    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a6792d826da47ac7ff7eea7ac959783f"];
    
    // 2. Create request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3. Create session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
//               NSLog(@"hi");
               
               // Create UIAlertController
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                            message:@"The internet connection appears to be offline."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
               // Create "Try Again" action + button
               UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                            style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                        // Try again; if not, doing nothing will dismiss the view
                   [self fetchMovies];
                                                                 }];
               // add the "Try Again" action to the alertController
               [alert addAction:tryAgainAction];
               
               // Show UIAlertController
               [self presentViewController:alert animated:YES completion:^{
                   // optional code for what happens after the alert controller has finished presenting
                   // TODO: do we need anything here?
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               // Stop the activity indicator after retrieving the data
               // Hides automatically if "Hides When Stopped" is enabled
               [self.activityIndicator stopAnimating];
               
               // Log results
//               NSLog(@"%@", dataDictionary);
               
               // Get the array of movies
               // Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
               
               // TODO: need to populate here for search bar
//               self.data = self.movies;
               self.filteredData = self.movies;

               
               // Log movies in for loop
//               for (int i = 0; i < [self.movies count]; i++)
//               {
//                   NSLog(@"%@", [self.movies objectAtIndex:i]);
//               }
               
               // Reload your table view data
               [self.tableView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    // 5. Send the request we just set up
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.movies.count;
//    NSLog(@"hi");
//    NSLog(@"%d", self.movies.count);
//    NSLog(@"%d", self.filteredData.count);
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
//    NSDictionary *movie = self.movies[indexPath.row];
    // Implement search bar
    NSDictionary *movie = self.filteredData[indexPath.row];
    
//    cell.textLabel.text = movie[@"title"];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL]; 
    
    return cell;

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
//        self.filteredData = self.data;
        self.filteredData = self.movies;
    }
    
    [self.tableView reloadData];
 
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    // Reset to no filter
    self.filteredData = self.movies;
    [self.tableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSLog(@"%d", [sender isKindOfClass: [MovieCell class]]);

    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *dataToPass = self.movies[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}


@end
