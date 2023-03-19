//
//  VCView.m
//  unlock
//
//  Created by 张青 on 2023/3/19.
//

#import "VCView.h"

@implementation VCView


- (void)drawRect:(CGRect)rect{
    UIImage *bg = [UIImage  imageNamed:@"Home_refresh_bg"];
    [bg drawInRect:rect];
}

@end
