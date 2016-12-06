//
//  ThirdViewController.m
//  WeexIOS
//
//  Created by yangfan on 16/12/6.
//  Copyright © 2016年 yfan. All rights reserved.
//

#import "ThirdViewController.h"
#import <WeexSDK/WeexSDK.h>
#import <SRWebSocket.h>

@interface ThirdViewController ()

@property (nonatomic, readwrite, strong) WXSDKInstance *instance;
@property (nonatomic, weak) UIView *weexView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认加载的地址为本地路径的bundlejs/index.js
    if (!self.url) {
        self.url = [[NSBundle mainBundle] pathForResource:@"bundlejs/index" ofType:@"js"];
    }
    [self render];//weex将js渲染成weex页面。
    
}

- (void)render{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:self.url];
    
    CGFloat width = self.view.frame.size.width;
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = CGRectMake(self.view.frame.size.width-width, 61, width, self.view.frame.size.height-61-50);
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    
    NSString *randomURL = [NSString stringWithFormat:@"%@?random=%d",URL.absoluteString,arc4random()];
    [_instance renderWithURL:[NSURL URLWithString:randomURL] options:@{@"bundleUrl":URL.absoluteString} data:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_instance destroyInstance];
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
