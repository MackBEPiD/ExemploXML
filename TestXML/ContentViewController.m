//
//  ContentViewController.m
//  TestXML
//
//  Created by Lucas Saito on 23/05/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize dados;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:[dados objectForKey:@"title"]];
    
    UIGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    webView = [[UIWebView alloc] init];
    [webView setFrame:self.view.frame];
    [webView loadHTMLString:[dados objectForKey:@"description"] baseURL:[NSURL URLWithString:[dados objectForKey:@"link"]]];
    
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"AUIUIUI");
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch view] == webView) {
        NSURL *url = [NSURL URLWithString:[dados objectForKey:@"link"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
}

@end
