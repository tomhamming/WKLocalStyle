//
//  ViewController.m
//  WKLocalStyle
//
//  Created by Thomas Hamming on 3/20/20.
//  Copyright © 2020 Thomas Hamming. All rights reserved.
//

#import "ViewController.h"
#import "WKStyleHandler.h"

@interface ViewController ()
@property (strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKStyleHandler *handler = [[WKStyleHandler alloc] init];
    [config setURLSchemeHandler:handler forURLScheme:@"myfile"];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.webView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.webView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    NSURL *url = [NSURL URLWithString:@"https://tomhamming.github.io/index.html"];
    
//    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error)
//        {
//            NSLog(@"Error downloading: %@", error);
//            return;
//        }
//
//        NSString *tempPath = NSTemporaryDirectory();
//        NSString *filePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html", [NSUUID UUID].UUIDString]];
//        NSError *err = nil;
//        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:&err];
//        if (err)
//        {
//            NSLog(@"Error moving file: %@", err);
//            return;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.webView loadFileURL:[NSURL fileURLWithPath:filePath] allowingReadAccessToURL:[NSURL fileURLWithPath:tempPath]];
//        });
//    }] resume];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"Load succeeded - running JS for style");
    
    NSString *strJs = @"var linkTag = document.createElement('link'); \
    linkTag.setAttribute('type', 'text/css'); \
    linkTag.setAttribute('rel', 'stylesheet'); \
    linkTag.setAttribute('href', 'myfile://bundle/style.css');\
    document.head.appendChild(linkTag);\
    \
    var imgTag = document.createElement('img');\
    imgTag.setAttribute('src', 'myfile://bundle/icon.png');\
    document.lastElementChild.appendChild(imgTag);";
    
    [self.webView evaluateJavaScript:strJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error && !([error.domain isEqualToString:WKErrorDomain] && error.code == WKErrorJavaScriptResultTypeIsUnsupported))
        {
            NSLog(@"Error inserting CSS: %@", error);
        }
    }];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"Failed navigation with error: %@", error);
}

@end
