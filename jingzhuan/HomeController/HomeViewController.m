//
//  HomeViewController.m
//  jingzhuan
//
//  Created by 刘飞龙 on 2019/7/1.
//  Copyright © 2019年 刘飞龙. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "MoneyDetailController.h"
#import "MineViewController.h"
#import "WorkListController.h"
#import "TiXianTypeViewController.h"
#import "LoginViewController.h"

#import "HomeTopView.h"
#import "HomeTableCell.h"
#import "HomeBottonBtnView.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *pressBtn;
@property (nonatomic,strong) UIButton *adversBtn;

@property (strong, nonatomic) HomeTopView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;
@property (strong, nonatomic) NSMutableArray *dateArray;
@property (strong, nonatomic) NSMutableArray *adverstArray;

@property (assign, nonatomic) BOOL isLogin;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self lanchImage];
    self.isLogin = NO;
    self.bottomY.constant = TAB_SAFE_HEIGHT;
    self.view.backgroundColor = [UIColor whiteColor];
    self.topView = [HomeTopView viewStand];
    self.topView.headerImage.hidden = YES;
    [self.topView.loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    __block HomeTopView *blockView = self.topView;
    WS(weakSelf);
    self.topView.buttonBlock = ^(NSInteger tag) {
        if (tag == 1) {
            //提现
            TiXianTypeViewController *txVC = [[TiXianTypeViewController alloc] init];
            txVC.title = @"提现方式";
            [weakSelf.navigationController pushViewController:txVC animated:YES];
        }else if (tag == 2 || tag == 3) {//2 3 收入明细
            MoneyDetailController *detailVC = [[MoneyDetailController alloc] init];
            detailVC.title = @"收入明细";
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else { // 4
            if (weakSelf.isLogin) {
                MineViewController *mine = [[MineViewController alloc] init];
                mine.title = @"我的";
                [weakSelf.navigationController pushViewController:mine animated:YES];
            }else {
                LoginViewController *login = [[LoginViewController alloc] init];
                login.loginSuccess = ^{
                    weakSelf.isLogin = YES;
                    [blockView.loginBtn setTitle:@"" forState:UIControlStateNormal];
                    blockView.headerImage.hidden = NO;
                };
                [weakSelf presentViewController:login animated:YES completion:nil];                
            }
            
        }
    };
    self.topView.frame = CGRectMake(0, -STATUS_HEIGHT, SCREEN_WIDTH, 300 - STATUS_HEIGHT);
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300 - STATUS_HEIGHT)];
    [topBackView addSubview:self.topView];
    self.tableView.tableHeaderView = topBackView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dateArray = [NSMutableArray arrayWithArray:
                      @[@{@"title":@"试玩",@"cellHight":@"130",@"cellType":@"0"},
                        @{@"title":@"抽奖1",@"cellHight":@"70",@"cellType":@"1"},
                        @{@"title":@"抽奖2",@"cellHight":@"70",@"cellType":@"2"},
                        @{@"title":@"按钮",@"cellHight":@"70",@"cellType":@"3"}]];
    
    [self requsetDate];
}

- (void)requsetDate {
    self.adverstArray = [NSMutableArray new];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *token = [UserDefaults valueForKey:@"token"]?[UserDefaults valueForKey:@"token"]:@"";
    NSString *userId = [UserDefaults valueForKey:@"userId"]?[UserDefaults valueForKey:@"userId"]:@"";
    
    NSDictionary *body = @{@"version":buildVersion,
                           @"token":token,
                           @"userId":userId};
    [[RequestTool tool] requsetWithController:self url:@"pub/config/init" body:body Success:^(id  _Nonnull result) {
        NSArray *openList = result[@"openAdvert"];
        if (openList.count > 0) {
            NSDictionary *openDict = openList[0];
            NSString *img = openDict[@"img"];
            NSString *url = openDict[@"url"];
            [UserDefaults setValue:img forKey:@"openImgUrl"];
            [UserDefaults setValue:url forKey:@"openAdvertUrl"];
        }else {
            [UserDefaults setValue:@"" forKey:@"openImgUrl"];
            [UserDefaults setValue:@"" forKey:@"openAdvertUrl"];
        }
        NSArray *indexAdvert = result[@"indexAdvert"];
        [self.adverstArray addObjectsFromArray:indexAdvert];
        NSString *boolNum = result[@"isLogin"];
        self.isLogin = [boolNum boolValue];
        if (self.isLogin) {
            [self.topView.loginBtn setTitle:@"" forState:UIControlStateNormal];
            self.topView.headerImage.hidden = NO;
        }
        [self.topView setMessageWith:result];
        
        NSString *upgrade = result[@"upgrade"];
        if ([upgrade isEqualToString:@"1"]) {
            [[AlertTool tool] alertWithTitle:@"提示" message:@"有版本更新，请立即更新" confirmBlock:^{
                NSString *verPath = result[@"verPath"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:verPath] options:@{} completionHandler:nil];
            }];
        }
        [self.tableView reloadData];
    } andFailure:^(NSString * _Nonnull errorType) {

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dateArray[indexPath.row];
    NSString *cellHight = dict[@"cellHight"];
    return [cellHight floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HomeTableCell";
    NSDictionary *dict = self.dateArray[indexPath.row];
    int cellType = [dict[@"cellType"] intValue];
    HomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil][cellType];
    }
    __block NSString *title = dict[@"title"];
    if ([title isEqualToString:@"按钮"]) {
        [cell setButtonViewWithArray:self.adverstArray];
    }else if ([title isEqualToString:@"试玩"]) {
        cell.btnWith.constant = (SCREEN_WIDTH - 32) / 5 * 2;
    }
    cell.buttonBlock = ^(NSInteger tag) {
        if ([title isEqualToString:@"试玩"]) {
            [self requestWorkListWithTag:tag];
            
        }else if ([title isEqualToString:@"按钮"]) {
            [self gotoWebControllerWithTag:tag];
        }else {
            [[AlertTool tool] alertWithTitle:@"敬请期待"];
        }
    };
    
    return cell;
}

- (void)requestWorkListWithTag:(NSInteger)tag {
    NSDictionary *body = @{@"type":[NSString stringWithFormat:@"%ld",tag],
                           @"showMessage":@"任务匹配中",
                           @"token":[UserDefaults valueForKey:@"token"],
                           @"userId":[UserDefaults valueForKey:@"userId"]};
    
    [[RequestTool tool] requsetWithController:self url:@"pub/task/taskList" body:body Success:^(id  _Nonnull result) {
        NSString *title = @"试玩赚钱";
        if (tag == 2) {
            title = @"高额礼金";
        }
        WorkListController *workList = [[WorkListController alloc] init];
        workList.title = title;
        workList.workDate = result;
        [self.navigationController pushViewController:workList animated:YES];
    } andFailure:^(NSString * _Nonnull errorType) {
        [SVProgressHUD showErrorWithStatus:errorType];
        [SVProgressHUD dismissWithDelay:5];
    }];
}

- (void)gotoWebControllerWithTag:(NSInteger)tag {
    NSDictionary *dict = self.adverstArray[tag - 1];
    NSString *url = dict[@"url"];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
//    WebViewController *webView = [[WebViewController alloc] init];
//    webView.title = @"这是广告";
//    webView.urlString = @"https://www.baidu.com";
//    [self.navigationController pushViewController:webView animated:YES];
}

- (void)lanchImage {
    [self.view addSubview:self.imageView];
    self.adversBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.adversBtn addTarget:self action:@selector(adversBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.adversBtn.frame = self.view.bounds;
    [self.view addSubview:self.adversBtn];
    self.pressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pressBtn.frame = CGRectMake(self.view.frame.size.width - 65, STATUS_HEIGHT + 10, 50, 30);
    self.pressBtn.layer.masksToBounds = YES;
    self.pressBtn.layer.cornerRadius = 15;
    self.pressBtn.alpha = 0.5;
    self.pressBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pressBtn];
    [self.pressBtn addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    
    [self setLoanchImage];
    
    WS(weakSelf);
    __block NSInteger timeout = 6; // 倒计时时间
    if (timeout!=0) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
        dispatch_source_set_event_handler(timer, ^{
            if(timeout <= 1){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                dispatch_source_cancel(timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf removeProgress];
                });
            } else { // 倒计时重新计算 时/分/秒
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *title = [NSString stringWithFormat:@"%lds",timeout];
                    [weakSelf.pressBtn setTitle:title forState:UIControlStateNormal];
                });
                timeout--; // 递减 倒计时-1(总时间以秒来计算)
            }
        });
        dispatch_resume(timer);
    }
    
}

- (void)adversBtnAction {
    NSString *advertUrl = [UserDefaults valueForKey:@"openAdvertUrl"];
    if (advertUrl.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:advertUrl] options:@{} completionHandler:nil];
    }
}

- (void)setLoanchImage {
    
    NSString *imageName = @"SE.png";
    if (IPHONE_X) {
        imageName = @"Default-iOS11-812h";
    }else if (IPHONE_XR) {
        imageName = @"iPhone XR.png";
    }else if (IPHONE_6P) {
        imageName = @"8p.png";
    }else if (IPHONE_6) {
        imageName = @"8.png";
    }
    NSString *imgUrl = [UserDefaults valueForKey:@"openImgUrl"]?[UserDefaults valueForKey:@"openImgUrl"]:@"";
    if (imgUrl.length < 3) {
        self.imageView.image = [UIImage imageNamed:imageName];
    }else {
       [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"imageName"]];
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
        NSString *imageName = @"SE.png";
        if (IPHONE_X) {
            imageName = @"Default-iOS11-812h";
        }else if (IPHONE_XR) {
            imageName = @"iPhone XR.png";
        }else if (IPHONE_6P) {
            imageName = @"8p.png";
        }else if (IPHONE_6) {
            imageName = @"8.png";
        }
        _imageView.image = [UIImage imageNamed:imageName];
    }
    return _imageView;
}

- (void)removeProgress {
    self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    self.imageView.alpha = 1;
    [self.adversBtn removeFromSuperview];
    [UIView animateWithDuration:0.7 animations:^{
        [self.pressBtn removeFromSuperview];
        self.imageView.alpha = 0.05;
        self.imageView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
