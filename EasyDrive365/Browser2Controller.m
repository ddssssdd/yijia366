//
//  Browser2Controller.m
//  EasyDrive366
//
//  Created by Steven Fu on 1/15/14.
//  Copyright (c) 2014 Fu Steven. All rights reserved.
//

#import "Browser2Controller.h"
#import "ArticleCommentViewController.h"

@interface Browser2Controller ()

@end

@implementation Browser2Controller

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
    if (self.url){
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else if (self.article){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看评论" style:UIBarButtonSystemItemFastForward target:self action:@selector(gotoShare)];
        NSString *_article_url;
        self.title = _article[@"title"];
        if ([_article[@"url"] hasPrefix:@"http://"]){
            _article_url = _article[@"url"];
        }else{
            _article_url = [NSString stringWithFormat:@"http://%@",_article[@"url"]];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_article_url]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)gotoShare{
    ArticleCommentViewController *vc = [[ArticleCommentViewController alloc] initWithNibName:@"ArticleCommentViewController" bundle:nil];
    vc.article = _article;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
