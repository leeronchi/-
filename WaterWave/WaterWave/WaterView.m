//
//  WaterView.m
//  WaterWave
//
//  Created by mobi on 16/1/6.
//  Copyright © 2016年 snapking. All rights reserved.
//

#import "WaterView.h"

@interface WaterView()
{
    UIColor *_waterColor;
    CGFloat _waterLineY;
    CGFloat _waveAmplitude;
    CGFloat _waveCycle;
    BOOL increase;
    CADisplayLink *_waveDisplayLink;
}

@end

@implementation WaterView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:72/255.0f green:210/255.0f blue:209/255.0f alpha:1]];
        _waveAmplitude=3.0;
        _waveCycle=1.0;
        increase=NO;
        _waterColor=[UIColor whiteColor];
        _waterLineY=20;
        
        
        _waveDisplayLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(runWave)];
        [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

-(void)runWave
{
    
    if (increase) {
        _waveAmplitude += 0.02;
    }else{
        _waveAmplitude -= 0.02;
    }
    
    
    if (_waveAmplitude<=1) {
        increase = YES;
    }
    
    if (_waveAmplitude>=2) {
        increase = NO;
    }
    
    _waveCycle+=0.1;
    
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    
    CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;
    
    //初始化画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //推入
    CGContextSaveGState(context);
    
    
    //定义前波浪path
    CGMutablePathRef frontPath = CGPathCreateMutable();
    //定义后波浪path
    CGMutablePathRef backPath=CGPathCreateMutable();
    //定义中波浪path
    CGMutablePathRef middlePath = CGPathCreateMutable();
    

    
    //定义前波浪反色path
    CGMutablePathRef frontReversePath = CGPathCreateMutable();
    //定义后波浪反色path
    CGMutablePathRef backReversePath=CGPathCreateMutable();
    //定义中波浪反色path
    CGMutablePathRef middleReversePath=CGPathCreateMutable();
    
    
    
    //画水
    CGContextSetLineWidth(context, 1);
    
    
    //前波浪位置初始化
    float frontY=_waterLineY;
    CGPathMoveToPoint(frontPath, NULL, 0, frontY);
    //前波浪反色位置初始化
    float frontReverseY=_waterLineY;
    CGPathMoveToPoint(frontReversePath, NULL, 0,frontReverseY);
    
    
    //中波浪位置初始化
    float middleY=_waterLineY;
    CGPathMoveToPoint(middlePath, NULL, 0, middleY);
    //中波浪反色位置初始化
    float middleReverseY=_waterLineY;
    CGPathMoveToPoint(middleReversePath, NULL, 0,middleReverseY);


    //后波浪位置初始化
    float backY=_waterLineY;
    CGPathMoveToPoint(backPath, NULL, 0, backY);
    //后波浪反色位置初始化
    float backReverseY=_waterLineY;
    CGPathMoveToPoint(backReversePath, NULL, 0, backReverseY);
    
    
    
    
    for(float x=0;x<=main_width;x++){
        
        //前波浪绘制
        frontY= _waveAmplitude * sin( x/(main_width/2)*M_PI + 4*_waveCycle/M_PI ) * 5 + _waterLineY;
        CGPathAddLineToPoint(frontPath, nil, x, frontY);
        
        
        //中波浪绘制
        middleY= _waveAmplitude * cos( x/(main_width/2)*M_PI + 3*_waveCycle/M_PI ) * 5 + _waterLineY;
        CGPathAddLineToPoint(middlePath, nil, x, middleY);
        
        //后波浪绘制
        backY= _waveAmplitude * sin( x/(main_width/2)*M_PI + 3*_waveCycle/M_PI ) * 5 + _waterLineY;
        CGPathAddLineToPoint(backPath, nil, x, backY);
        
        
        
        
        if (x>=100) {
            
            //后波浪反色绘制
            backReverseY= _waveAmplitude * cos( x/(main_width/2)*M_PI + 3*_waveCycle/M_PI ) * 5 + _waterLineY;
            CGPathAddLineToPoint(backReversePath, nil, x, backReverseY);
            
            //中波浪反色绘制
            middleReverseY= _waveAmplitude * sin( x/(main_width/2)*M_PI + 4*_waveCycle/M_PI ) * 5 + _waterLineY;
            CGPathAddLineToPoint(middleReversePath, nil, x, middleReverseY);
            
            //前波浪反色绘制
            frontReverseY= _waveAmplitude * cos( x/(main_width/2)*M_PI + 4*_waveCycle/M_PI ) * 5 + _waterLineY;
            CGPathAddLineToPoint(frontReversePath, nil, x, frontReverseY);
        }
    }
    
    //后波浪绘制
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:128/255.0 green:228/255.0 blue:220/255.0 alpha:1] CGColor]);
    CGPathAddLineToPoint(backPath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(backPath, nil, 0, rect.size.height);
    CGPathAddLineToPoint(backPath, nil, 0, _waterLineY);
    CGPathCloseSubpath(backPath);
    CGContextAddPath(context, backPath);
    CGContextFillPath(context);
    
    //推入
    CGContextSaveGState(context);
    
    //后波浪反色绘制
    CGPathAddLineToPoint(backReversePath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(backReversePath, nil, 100, rect.size.height);
    CGPathAddLineToPoint(backReversePath, nil, 100, _waterLineY);
    
    CGContextAddPath(context, backReversePath);
    CGContextClip(context);

    //弹出
    CGContextRestoreGState(context);
    
    
    
    
    
    
    
    
    
    //中波浪绘制
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:190/255.0 green:254/255.0 blue:249/255.0 alpha:1] CGColor]);
    CGPathAddLineToPoint(middlePath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(middlePath, nil, 0, rect.size.height);
    CGPathAddLineToPoint(middlePath, nil, 0, _waterLineY);
    CGPathCloseSubpath(middlePath);
    CGContextAddPath(context, middlePath);
    CGContextFillPath(context);
    
    //推入
    CGContextSaveGState(context);
    
    //中波浪反色绘制
    CGPathAddLineToPoint(middleReversePath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(middleReversePath, nil, 100, rect.size.height);
    CGPathAddLineToPoint(middleReversePath, nil, 100, _waterLineY);
    
    CGContextAddPath(context, middleReversePath);
    CGContextClip(context);
    
    //弹出
    CGContextRestoreGState(context);
    
    
    
    
    
    
    
    
    //前波浪绘制
    CGContextSetFillColorWithColor(context, [_waterColor CGColor]);
    CGPathAddLineToPoint(frontPath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(frontPath, nil, 0, rect.size.height);
    CGPathAddLineToPoint(frontPath, nil, 0, _waterLineY);
    CGPathCloseSubpath(frontPath);
    CGContextAddPath(context, frontPath);
    CGContextFillPath(context);
    
    //推入
    CGContextSaveGState(context);
    
    
    //前波浪反色绘制
    CGPathAddLineToPoint(frontReversePath, nil, main_width, rect.size.height);
    CGPathAddLineToPoint(frontReversePath, nil, 100, rect.size.height);
    CGPathAddLineToPoint(frontReversePath, nil, 100, _waterLineY);
    
    CGContextAddPath(context, frontReversePath);
    CGContextClip(context);

    
    //推入
    CGContextSaveGState(context);
    
    
    
    
    
    
    
    
    //释放
    CGPathRelease(backPath);
    CGPathRelease(backReversePath);
    CGPathRelease(frontPath);
    CGPathRelease(frontReversePath);
    CGPathRelease(middlePath);
    CGPathRelease(middleReversePath);
    
}

@end
