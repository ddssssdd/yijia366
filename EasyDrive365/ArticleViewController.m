//
//  ArticleViewController.m
//  EasyDrive366
//
//  Created by Fu Steven on 6/10/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleCommentViewController.h"

@interface ArticleViewController (){
    id _article;
}

@end

@implementation ArticleViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonSystemItemFastForward target:self action:@selector(gotoShare)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
    
}
-(void)goto:(id)article{
    //NSLog(@"%@",article);
    _article = article;
    
    NSString *_article_url;
    if ([_article[@"url"] hasPrefix:@"http://"]){
        _article_url = _article[@"url"];
    }else{
        _article_url = [NSString stringWithFormat:@"http://%@",_article[@"url"]];
    }
    
    NSURL *open_url =[NSURL URLWithString:_article_url];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:open_url];

    [self.webView loadRequest:request];
    self.title = _article[@"title"];
}
-(void)gotoShare{
    ArticleCommentViewController *vc = [[ArticleCommentViewController alloc] initWithNibName:@"ArticleCommentViewController" bundle:nil];
    vc.article = _article;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
