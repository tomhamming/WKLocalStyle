//
//  WKStyleHandler.m
//  WKLocalStyle
//
//  Created by Thomas Hamming on 3/20/20.
//  Copyright © 2020 Thomas Hamming. All rights reserved.
//

#import "WKStyleHandler.h"

@implementation WKStyleHandler

-(void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{
    NSURL *reqUrl = urlSchemeTask.request.URL;
    NSURL *url = [[NSBundle mainBundle] URLForResource:[reqUrl.lastPathComponent stringByDeletingPathExtension] withExtension:reqUrl.pathExtension];
    NSString *mime = nil;
    if ([reqUrl.pathExtension isEqualToString:@"css"])
        mime = @"text/css";
    else if ([reqUrl.pathExtension isEqualToString:@"otf"])
        mime = @"font/otf";
    else if ([reqUrl.pathExtension isEqualToString:@"png"])
        mime = @"image/png";

    if (url)
    {
        NSLog(@"Loading bundle URL '%@'", reqUrl);
        NSURLResponse *response = [[NSURLResponse alloc]initWithURL:reqUrl MIMEType:mime expectedContentLength:-1 textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:response];
        
        NSData *textData = [NSData dataWithContentsOfURL:url];
        [urlSchemeTask didReceiveData:textData];
        [urlSchemeTask didFinish];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:@"com.olivetree.otfile_url_error_domain" code:404 userInfo:nil];
        [urlSchemeTask didFailWithError:error];
        NSLog(@"Failed to load file from URL: %@", urlSchemeTask.request.URL);
    }
}

-(void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask
{
}

@end
