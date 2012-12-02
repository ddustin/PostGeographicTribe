//
//  ViewController.m
//  PostGeographicTribe
//
//  Created by Dustin Dettmer on 12/1/12.
//  Copyright (c) 2012 Dustin Dettmer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) GTMOAuthAuthentication *mAuth;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)isSignedIn
{
    return [[self.tripIt auth] hasAccessToken];
}

- (IBAction)dotheshitz:(id)sender {
    
    [self signInToTripIt];
}

- (void)signInToTripIt
{
    self.tripIt = [TripIt new];
    
    // uncomment the line below to test complete OAuth flow
    [self.tripIt setConsumerKey:@"2b785575d91647d6e3d6d0bc027da8186878eacd"
                 consumerSecret:@"86c0d63f2f2fd101204189abad66e2b8d03410bc"
                     oauthToken:nil
               oauthTokenSecret:nil];
    
    self.tripIt.delegate = self;
    
    if(!self.tripIt.auth.hasAccessToken)
        [self.tripIt performOauthFlow];
}

- (void)doAnAuthenticatedAPIFetch
{
    [self.tripIt testApiGet];
}

// Implement TripItApiDelegate protocol
- (void)oauthReturned:(GTMOAuthAuthentication *)returnedAuth error:(NSError *)error
{
    NSLog(@"Oauth Returned:");
    NSMutableString *returnStr = [NSMutableString string];
    
    if (error != nil) {
        // Authentication failed (perhaps the user denied access, or closed the
        // window before granting access)
        [returnStr appendString:@"Authentication error: "];
        NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
        if ([responseData length] > 0) {
            // show the body of the server's authentication failure response
            [returnStr appendString:[[NSString alloc] initWithData:responseData
                                                           encoding:NSUTF8StringEncoding]];
        }
    }
    else {
        [returnStr appendString:@"Auth COMPLETED"];
    }
    NSLog(@"%@", returnStr);
    
    [self doAnAuthenticatedAPIFetch];
}

// Implement TripItApiDelegate protocol
- (void)apiReturnedWithString:(NSString *)returnStr error:(NSError *)error
{
    if (error != nil) {
        // failed; either an NSURLConnection error occurred, or the server returned
        // a status value of at least 300
        //
        // the NSError domain string for server status errors is kGTMHTTPFetcherStatusDomain
        int status = [error code];
        // fetch failed
        NSLog(@"API fetch error: %d - %@", status, error);
    }
    self.text.text = returnStr;
    NSLog(@"API response: %@", returnStr);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
