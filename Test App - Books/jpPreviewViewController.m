//
//  jpPreviewViewController.m
//  Test App - Books
//
//  Created by Jakub on 21.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import "jpPreviewViewController.h"

@interface jpPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *previewWebView;

@end

@implementation jpPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *nsUrl = [NSURL URLWithString:self.previewUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.previewWebView loadRequest:request];
}

@end
