//
//  GridViewController.m
//  Flixter
//
//  Created by Kathy Zhong on 6/16/22.
//

#import "GridViewController.h"
#import "PosterCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"


//@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
//@interface GridViewController ()
@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *movies;
//@property (nonatomic, strong) NSMu tableArray *posterPaths;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (strong, nonatomic) NSArray *data;
//@property (strong, nonatomic) NSArray *filteredData;


@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Start the activity indicator
    [self.activityIndicator startAnimating];
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // Implement search bars
//    self.searchBar.delegate = self;
    
    // Call fetchMovies method
    [self fetchMovies];
    
    // Implement refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    // Customize navigation bar
    // Change back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back to Movies" style:UIBarButtonItemStylePlain target:nil action:nil];
}
//
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
//               NSLog(@"%@", self.movies);
               
               // TODO: need to populate here for search bar
//               self.data = self.movies;
//               self.filteredData = self.movies;

// https://stackoverflow.com/questions/10224762/how-to-initialize-an-empty-mutable-array-in-objective-c
//               self.posterPaths = [[NSMutableArray alloc] init];
//               for (int i = 0; i < [self.movies count]; i++)
//               {
////                   NSLog(@"%@", self.movies[i][@"poster_path"]);
//                   [self.posterPaths addObject:self.movies[i][@"poster_path"]];
//               }
//               NSLog(@"%@", self.movies);
//               NSLog(@"%@", self.posterPaths);

               // Reload your collection view data
               [self.collectionView reloadData];
           }
        [self.refreshControl endRefreshing];
       }];
    // 5. Send the request we just set up
    [task resume];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
//    return self.filteredData.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return nil;
//    UICollectionViewC ell *cell = [[UICollectionViewCell alloc] init];
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    // Implement search bar
//    NSDictionary *movie = self.filteredData[indexPath.row];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.collectionsPosterView.image = nil;
    [cell.collectionsPosterView setImageWithURL:posterURL];
    
//    NSLog(@"%@", [NSString stringWithFormat:@"row: %ld, section: %ld", indexPath.row, indexPath.section]);
    
//    cell.textLabel.text = [NSString stringWithFormat:@"row: %ld, section: %ld", indexPath.row, indexPath.section]; // skipped because collection view cells don't have text labels
    
    return cell;
}

/*
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
    
    [self.collectionView reloadData];
 
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
    [self.collectionView reloadData];
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    NSLog(@"%d", [sender isKindOfClass: [PosterCell class]]);
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    NSDictionary *dataToPass = self.movies[indexPath.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.detailDict = dataToPass;
}




@end
