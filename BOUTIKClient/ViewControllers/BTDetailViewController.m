//
//  BTDetailViewController.m
//  BOUTIKClient
//
//  Created by Kent on 15/11/17.
//  Copyright © 2015年 kent. All rights reserved.
//

#import "BTDetailViewController.h"

@interface BTDetailViewController ()
{
    UILabel *lab;
}

@end

@implementation BTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//禁止scroll view的内容自动调整,少这段代码，会有20像素的留白
    
    
   UIScrollView * mainScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    mainScorllView.pagingEnabled = YES;
    mainScorllView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight+100);
    mainScorllView.bounces = YES;
    [self.view addSubview:mainScorllView];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    img.image = self.sci_img;
    [mainScorllView addSubview:img];
    UITextView *text = [[UITextView alloc]init];
    text.frame = CGRectMake(0, mainScorllView.frame.size.height + 5, ScreenWidth, 100);
    text.text = self.title;
    [mainScorllView addSubview:text];
    
    UIButton *bun = [UIButton buttonWithType:UIButtonTypeCustom];
    bun.frame = CGRectMake(15, ScreenHeight - 110, 40, 25);
    [bun setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [mainScorllView addSubview:bun];
    bun.layer.cornerRadius = 5;
    bun.clipsToBounds = YES;
    [bun addTarget:self action:@selector(diss) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *likeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 75, bun.frame.origin.y, 60, 25)];
    likeImgV.image = [UIImage imageNamed:@"backGround"];
    likeImgV.userInteractionEnabled = YES;
    likeImgV.layer.cornerRadius = 3;
    likeImgV.clipsToBounds = YES;
    [mainScorllView addSubview:likeImgV];
    
    UIButton *likebun = [UIButton buttonWithType:UIButtonTypeCustom];
    likebun.frame = CGRectMake(5, 0, 25, 25);
    likebun.tag = 1212;
    [likebun setImage:[UIImage imageNamed:@"goodNormal"] forState:UIControlStateNormal];
    [likebun setImage:[UIImage imageNamed:@"goodSelect"] forState:UIControlStateSelected];
    [likeImgV addSubview:likebun];
    [likebun addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];

    lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likebun.frame)+5, likebun.frame.origin.y, 30, 25)];
    lab.textColor = [UIColor whiteColor];
    lab.tag = 1323;
    lab.text = self.goodCount;
    [likeImgV addSubview:lab];

}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"时尚，从拍衣服开始";
}

//返回
- (void)diss
{
    [self.navigationController popViewControllerAnimated:NO];
}

//点赞
-(void)like:(UIButton *)sender
{
    
    NSString *str = self.article_id;
    str = [NSString stringWithFormat:@"http://120.24.69.76/api/appAPI2.php?action=like&article_id=%@",str];
    NSURL *url = [NSURL URLWithString:str];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"-----%@-----",dict);
            lab.text = dict[@"result"];
            UIButton *bun = sender;
            bun.selected = YES;
            bun.userInteractionEnabled = NO;
        }
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
