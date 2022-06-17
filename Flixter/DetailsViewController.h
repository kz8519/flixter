//
//  DetailsViewController.h
//  Flixter
//
//  Created by Kathy Zhong on 6/15/22.
//

#import <UIKit/UIKit.h> 

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) NSDictionary *detailDict;
- (IBAction)trailerButton:(id)sender;



@end

NS_ASSUME_NONNULL_END
