//
//  ViewController.m
//  unlock
//
//  Created by 张青 on 2023/3/19.
//

#import "ViewController.h"
#import "LockView.h"
#import "VCView.h"

@interface ViewController ()
@property (nonatomic, strong) VCView *vcView;
@property (nonatomic, strong) LockView *lockView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.vcView];
    [self.vcView addSubview:self.lockView];
}


- (LockView *)lockView{
    if(!_lockView){
        _lockView = [[LockView alloc]initWithFrame:self.view.bounds];
        _lockView.backgroundColor = [UIColor clearColor];
    }
    return _lockView;
}

- (VCView *)vcView{
    if(!_vcView){
        _vcView = [[VCView alloc]initWithFrame:self.view.bounds];
    }
    return _vcView;
}

@end
