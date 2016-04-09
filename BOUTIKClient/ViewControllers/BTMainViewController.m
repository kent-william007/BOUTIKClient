//
//  BTMainViewController.m
//  BOUTIKClient
//
//  Created by Kent on 15/11/16.
//  Copyright © 2015年 kent. All rights reserved.
//

#import "BTMainViewController.h"
#import "BTModel.h"
#import "BTDetailViewController.h"
#import "MKNetworkKit.h"
#import "MBProgressHUD.h"
#import "Communication.h"
@interface BTMainViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    NSMutableArray *article_idArr;
    NSOperationQueue *queue;
    NSMutableArray *_scrollImageArr;
    MBProgressHUD *_progress;
}

@end

@implementation BTMainViewController
@synthesize mainScorllView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//禁止scroll view的内容自动调整,少这段代码，会有20像素的留白

    
    mainScorllView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
    mainScorllView.pagingEnabled = YES;
    mainScorllView.contentSize = CGSizeMake(ScreenWidth*6,ScreenHeight-64);
    mainScorllView.bounces = YES;
    mainScorllView.delegate = self;
    
    //获取图像

    
    [self.view addSubview:mainScorllView];
    
    UIButton *bun = [UIButton buttonWithType:UIButtonTypeCustom];
    bun.center = CGPointMake(ScreenWidth/2, ScreenHeight - 30);
    bun.bounds = CGRectMake(0, 0, 50, 50);
    [bun setImage:[UIImage imageNamed:@"tokePhoto"] forState:UIControlStateNormal];
    [bun addTarget:self action:@selector(changeUserLogoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bun];

    _scrollImageArr = [NSMutableArray array];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"时尚，从拍衣服开始";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_progress removeFromSuperview];
}

#pragma mark -求数据
- (void)requestData
{
    _progress = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    _progress.color = [UIColor lightGrayColor];
    _progress.labelColor = [UIColor whiteColor];
    _progress.labelText = @"正在加载...";

    //获取
    [[Communication sharedInstance]communicationHostName:@"120.24.69.76:8983/solr/collection2" andpath:@"select?q=*:*&start=0&rows=6&sort=sci_time desc,sci_digg_count desc&wt=json&indent=true" andParameters:nil andSuccess:^(NSString *transName, id respondseObject, int dataType) {
        if (respondseObject) {
            NSArray *arr = respondseObject[@"response"][@"docs"];
            for (NSDictionary *dic in arr) {
                BTModel *model = [[BTModel alloc]init];
                model.sci_imageUrl = dic[@"sci_image"];
                model.article_id = dic[@"id"];
                [_scrollImageArr addObject:model];
                if (_scrollImageArr.count == 6) {
                    [self loadImage:_scrollImageArr];
                }
            }
        }
    } andFailure:^(NSString *transName, NSError *error) {
        NSLog(@"%@",error);
    }];

}
- (void)loadImage:(NSArray *)loadImageArr;
{
    NSMutableArray *picArr = [NSMutableArray array];
    queue = [NSOperationQueue mainQueue];
    
    __block NSInteger i=0;
    
    for (BTModel *model in loadImageArr) {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.sci_imageUrl]] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                [_progress hide:YES];
                [picArr addObject:data];
                model.sci_image = data;
                UIImageView *imgV =   [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight-64)];
                i++;
                imgV.image = [UIImage imageWithData:data];
                [mainScorllView addSubview:imgV];
                imgV.userInteractionEnabled = YES;
                imgV.tag = 102+i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail:)];
                [imgV addGestureRecognizer:tap];
            }
        }];

    }
    
}

#pragma mark -点击手势
-(void)detail:(UITapGestureRecognizer *)tapGesture
{
    [_progress show:YES];
    
    UITapGestureRecognizer *tap = tapGesture;
    UIImageView *img = (UIImageView *)tap.view;
    BTModel *btmodel = (BTModel *)_scrollImageArr[img.tag - 102];
    NSString *str = btmodel.article_id;
    str = [NSString stringWithFormat:@"http://120.24.69.76/api/appAPI2.php?action=article_detail&article_id=%@",str];
    NSURL *url = [NSURL URLWithString:str];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

            BTDetailViewController *btdetail = [[BTDetailViewController alloc]init];
            btdetail.sci_img = img.image;
            btdetail.title = dict[@"title"];
            btdetail.article_id = btmodel.article_id;
            
            NSString *str = btmodel.article_id;
            str = [NSString stringWithFormat:@"http://120.24.69.76/api/appAPI2.php?action=like&article_id=%@",str];
            NSURL *url = [NSURL URLWithString:str];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    btdetail.goodCount = dict[@"result"];
                    
                    [_progress show:NO];
                    [self.navigationController pushViewController:btdetail animated:NO];

                }
            }];
        }
    }];
}

#pragma mark -changeUserLogoAction  改变头像
- (void)changeUserLogoAction:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选取",nil];
    [actionSheet  showInView:self.view];
}

#pragma mark -UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }else {
                return;
            }
        } else if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark -UIImagePickerController delgate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MBProgressHUD * progress = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    progress.color = [UIColor lightTextColor];
    progress.labelColor = [UIColor whiteColor];
    progress.labelText = @"正在上传...";

    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200, 100, 100)];
    [self.view addSubview:imgv];
    imgv.image = info[UIImagePickerControllerOriginalImage];
    [self.view addSubview:imgv];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating %@",scrollView);
//    if (scrollView==mainScorllView) {
//        CGPoint currentPoint = scrollView.contentOffset;
//
//        if (currentPoint.x > 4* ScreenWidth) {
//            [mainScorllView setContentOffset:CGPointMake(0, 0) animated:NO];
//
//        }
//        if (currentPoint.x<0) {
//            mainScorllView.contentOffset = CGPointMake(4*ScreenWidth, 0);
//
//        }
//    }
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"did-----%@",scrollView);
//    if (scrollView==mainScorllView) {
//        CGPoint currentPoint = scrollView.contentOffset;
//        
//        if (currentPoint.x > 4* ScreenWidth) {
//            [mainScorllView setContentOffset:CGPointMake(0, 0) animated:NO];
//            
//        }
//        if (currentPoint.x<0) {
//            mainScorllView.contentOffset = CGPointMake(4*ScreenWidth, 0);
//        }
//    }
//
//}
//- (void)refreashImageViewFrame
//{
//    if ( mainScorllView.contentOffset.x > ScreenWidth * 4 ||
//        mainScorllView.contentOffset.x < 0  )
//    {
//        //        if ( !scrollToTop )
//        //        {
//        //            scrollToTop = YES;
//        //            [m_timer setFireDate:[NSDate distantFuture]];
//        //        }
//        CGPoint _point = CGPointZero;
////        _point = ( m_scrollView.contentOffset.x < 0 ) ? CGPointMake(width, 0) : CGPointZero;
////        if ( m_scrollView.contentOffset.x < 0 )
////        {
////            m_currentPage = 1;
////        }
////        else
////            m_currentPage = [m_dataSource count];
//        
//        [mainScorllView setContentOffset:_point animated:NO];
//        
//        for ( UIImageView *_image in [mainScorllView subviews] )
//        {
//            CGRect _frame = _image.frame;
//            _frame.origin.x += ScreenWidth;
//            _frame.origin.x = (int)_frame.origin.x % (int)(ScreenWidth * 5);
//            _image.frame = _frame;
//        }
//    }
//}
//

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     NSLog(@"scrollViewWillBeginDragging %@",scrollView);
}
// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    NSLog(@"scrollViewWillEndDragging %@",scrollView);

}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging %@",scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView   // called on finger up as we are moving
{
    NSLog(@"scrollViewWillBeginDecelerating %@",scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
        NSLog(@"scrollViewDidEndScrollingAnimation %@",scrollView);
}




@end
