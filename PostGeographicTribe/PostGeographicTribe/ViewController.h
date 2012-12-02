//
//  ViewController.h
//  PostGeographicTribe
//
//  Created by Dustin Dettmer on 12/1/12.
//  Copyright (c) 2012 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripIt.h"

@interface ViewController : UIViewController<TripItApiDelegate>

@property (nonatomic, strong) TripIt *tripIt;

- (void)signInToTripIt;

- (BOOL)isSignedIn;

@end
