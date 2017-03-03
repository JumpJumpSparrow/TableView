//
//  BaseWebViewController.m
//  Ronghemt
//
//  Created by MiaoCF on 2017/2/20.
//  Copyright © 2017年 HLSS. All rights reserved.
//

#import "BaseWebViewController.h"
#import "MCFNetworkManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"

@interface BaseWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, assign) dispatch_once_t onceToken;
@property (nonatomic, strong) WKWebViewConfiguration *configuration;
@end

@implementation BaseWebViewController

- (WKWebViewConfiguration *)configuration {
    if (_configuration == nil) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goDetail"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goToBaoLiao"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goNavigationDetail"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"switchPages"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goToMoreProgram"];
        [_configuration.userContentController addScriptMessageHandler:self name:@"goBack"];
    }
    return _configuration;
}

- (WKWebView *)contentWebView {
    if (_contentWebView == nil) {

        _contentWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.configuration];
        _contentWebView.UIDelegate = self;
        _contentWebView.navigationDelegate = self;
    }
    return _contentWebView;
}

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.contentWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.hideNavi) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.contentWebView.frame = self.view.bounds;
    dispatch_once(&_onceToken, ^{
        if (self.url.length > 0) [self loadRequest:self.url];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
- (void)loadRequest:(NSString *)url {
    if (url.length == 0) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.contentWebView loadRequest:request];
}


- (NSDictionary *)getDictionaryWithJsonString:(NSString *)json {
    if (json.length == 0) return nil;
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) return nil;
    return dict;
}

#pragma mark - WKWebViewDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@ == %@", message.name, message.body);
    
    NSDictionary *dict = message.body;
    if (dict == nil) return;
    
    if ([message.name isEqualToString:@"goDetail"]) {
        NSString *url = dict[@"loadUrl"];
        //NSString *title = dict[@"title"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithUrl:url];
        //webVC.title = title;
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.hideNavi = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([message.name isEqualToString:@"goNavigationDetail"]) {
        NSString *url = dict[@"loadUrl"];
        NSString *title = dict[@"title"];
        BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithUrl:url];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.title = title;
        webVC.hideNavi = NO;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    if ([message.name isEqualToString:@"switchPages"]) {
        NSInteger index = [dict[@"firstMenu"] integerValue];
        NSInteger subIndex = [dict[@"secMenu"] integerValue];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.rootVc switchToIndex:index subIndex:subIndex];
    }
    
    if ([message.name isEqualToString:@"goToBaoLiao"]) {
        
    }
    
    if ([message.name isEqualToString:@"goBack"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showLoading];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideLoading];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hideLoading];
}

// realese the delegate here!
- (void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
