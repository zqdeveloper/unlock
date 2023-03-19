//
//  LockView.m
//  unlock
//
//  Created by 张青 on 2023/3/19.
//

#import "LockView.h"

@interface LockView ()
@property (nonatomic, strong) NSMutableArray<UIButton*> *selectBtn;
@property (nonatomic, assign) CGPoint curP;
@end

@implementation LockView


- (NSMutableArray<UIButton *> *)selectBtn{
    if(!_selectBtn){
        _selectBtn = [NSMutableArray array];
    }
    return _selectBtn;
}

- (void)drawRect:(CGRect)rect{
    //如果数组当中没有元素,就不让它进行绘图.直接返回.
    if(self.selectBtn.count<=0) return;
    //创建路径.
    UIBezierPath *path = [UIBezierPath bezierPath];
    //取出所有保存的选中按钮连线.
    for(int i = 0; i < self.selectBtn.count;i++){
        UIButton *btn = self.selectBtn[i];
        //判断当前按钮是不是第一个,如果是第一个,把它的中心设置为路径的起点.
        if(i == 0){
            //设置起点.
            [path moveToPoint:btn.center];
        }else{
            //添加一根线到当前按钮的圆心.
            [path addLineToPoint:btn.center];
        }
    }
    //连完先中的按钮后, 在选中按钮之后,添加一根线到当前手指所在的点.
    [path addLineToPoint:self.curP];
    //设置颜色
    [[UIColor redColor] set];
    //设置线宽
    [path setLineWidth:10];
    //设置线的连接样式
    [path setLineJoinStyle:kCGLineJoinRound];
    //绘制路径.
    [path stroke];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

-(void)setup {
    for(int i=0;i<9;i++){
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        button.tag = i;
        [self addSubview:button];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat column = 80;
    CGFloat padding = 40;
    CGFloat wMargin = (self.frame.size.width - column * 3 -padding *2)*0.5;
    CGFloat hMargin = (self.frame.size.height - column * 3 -padding * 2)*0.5;
    NSArray<UIButton *> *btns = self.subviews;
    CGFloat x = wMargin ,y= hMargin;
    for (int i=0;i<[btns count]; i++) {
        UIButton *btn = [btns objectAtIndex: i];
        btn.layer.cornerRadius = column / 2;
        btn.frame = CGRectMake(x, y, column, column);
        x = x +column + padding;
        if((i+1)%3 == 0) {
            x = wMargin;
            y = y + column + padding;
        }
    }
}
/*
*  获取当前手指所在的点
*
*  @param touches touches集合
*
*  @return 当前手指所在的点.
*/
- (CGPoint)getCurrentPoint:(NSSet *)touches{
   
   UITouch *touch = [touches anyObject];
   return [touch locationInView:self];
}


/**
*  判断一个点在不在按钮上.
*
*  @param point 当前点
*
*  @return 如果在按钮上, 返回当前按钮, 如果不在返回nil.
*/
- (UIButton *)btnRectContainsPoint:(CGPoint)point{

   for (UIButton *btn in self.subviews) {
       
       if (CGRectContainsPoint(btn.frame, point)) {
           //在按钮上.返回当前按钮
           return btn;
       }
   }
   return nil;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:point];
    if(btn && btn.selected == NO){
        btn.selected = YES;
        [self.selectBtn addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self getCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:point];
    if(btn && btn.selected  == NO){
        btn.selected = YES;
        [self.selectBtn addObject:btn];
    }
    [self setNeedsDisplay];
    self.curP = point;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.selectBtn.count>0){
        NSMutableString *str = [NSMutableString string];
        for(UIButton *btn in self.selectBtn){
            [str appendFormat:@"%ld",btn.tag];
            btn.selected = NO;
        }
        [self.selectBtn removeAllObjects];
        [self setNeedsDisplay];
        //查看是否是第一次设置密码
        NSString *keyPwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyPwd"];
        if (!keyPwd) {
         [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"keyPwd"];
         [[NSUserDefaults standardUserDefaults] synchronize];
             NSLog(@"第一次输入密码");
        }else{
            if ([keyPwd isEqualToString:str]) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"手势输入正确" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
                
                
            }else{
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"手势输入错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            }
        }
        NSLog(@"选中按钮顺序为:%@",str);
    }
    
}

@end
