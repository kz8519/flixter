//
//  TrailerViewController.h
//  Flixter
//
//  Created by Kathy Zhong on 6/17/22.
//


// Followed https://developers.google.com/youtube/v3/guides/ios_youtube_helper

#import <UIKit/UIKit.h>
#import <YTPlayerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrailerViewController : UIViewController
@property (nonatomic, strong) NSDictionary *detailDict;
@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;

@end

NS_ASSUME_NONNULL_END
