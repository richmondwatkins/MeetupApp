//
//  WebViewController.m
//  MeetMeUp
//
//  Created by Richmond on 10/13/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (IBAction)onBackButtonPressed:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)onForwardButtonPressed:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
@end
