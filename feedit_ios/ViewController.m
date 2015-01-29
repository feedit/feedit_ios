//
//  ViewController.m
//  feedit_ios
//
//  Created by xdf on 12/5/14.
//  Copyright (c) 2014 xdf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSString *API;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.API = @"http://xudafeng.com/feedit";
    [self setNavButton];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh {
    [self getData];
}
- (void)setNavButton {
    self.navigationItem.title = @"Feedit";
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItems=@[refreshButton];
}

- (void)loadWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webView setScalesPageToFit:YES];
    [self.webView setDelegate:self];
    [self.view addSubview: self.webView];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"assets/index" ofType:@"html"];
    NSString* html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:html baseURL:baseURL];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.2];
    [self.view addSubview:view];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview: self.activityIndicator];
    [self.activityIndicator startAnimating];
    NSLog(@"webViewDidStartLoad");
}

- (void)getData {
    NSError *error;
    NSURL *url = [NSURL URLWithString: self.API];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *djson = [json objectForKey:@"data"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:djson options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonobject: %@", jsonString);
    NSString *str = @"";
    jsonString = [str stringByAppendingFormat:@"Ready(%@)", jsonString];
    NSLog(@"%@", jsonString);
    [self.webView stringByEvaluatingJavaScriptFromString:jsonString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self getData];
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"didFailLoadWithError:%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.mainDocumentURL;
    NSString *string=[url absoluteString];
    NSString *str = [string substringToIndex:4];
    
    if ([str  isEqual: @"http"]) {
        NSLog(@"http");
        NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"window.targetUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return false;
    } else if ([str  isEqual: @"file"]) {
        NSLog(@"file");
        return true;
    } else {
        NSLog(@"other");
    }
    return true;
}
@end
