//
//  ClockView.m
//  Clock
//
//  Created by hudongyang on 2019/6/10.
//  Copyright © 2019 hudongyang. All rights reserved.
//

#import "ClockView.h"

static const CGFloat OUTER_LINE_WIDTH = 10;  // 外圆线宽
static const CGFloat INNER_LINE_WIDTH = 2; // 内圆线宽
static const CGFloat LONG_TICK_LENGTH = 12; // 长针长度
static const CGFloat SHORT_TICK_LENGTH = 8; // 短针长度
static const CGFloat LONG_TICK_WIDTH = 3; // 长针线宽
static const CGFloat SHORT_TICK_WIDTH = 1; // 短针线宽


@interface ClockView ()
@property (nonatomic, readonly) UIColor *blackColor; // 黑色
@property (nonatomic, readonly) CGFloat angleUnit; // 每个刻度间的角度
@end

@implementation ClockView

- (void)drawRect:(CGRect)rect {
    // 坐标系X轴默认水平，在3点位置，此处逆时针旋转90度让起点在12点位置。便于画图。
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    self.transform = CGAffineTransformRotate(transform, -M_PI_2);
    
    [self drawCircles];
    [self drawTicks];
    [self drawNumbers];
    
    [self drawHands];
}

- (void)drawCenter {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:6 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [self.blackColor setFill];
    
    [path fill];
}

- (void)drawHands {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components:units fromDate:NSDate.date];
    
    [self drawHourHand:components];
    [self drawMinuteHand:components.minute];
    [self drawSecondHand:components.second];
    [self drawCenter];
}

- (void) drawHourHand: (NSDateComponents *)components {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat radius = MIN(size.width, size.height) / 2 - 100;
    
    CGFloat hourAngle = ((components.hour + components.minute / 60.0) / 12.0) * M_PI * 2 - 3 * 5 * self.angleUnit;
    
    CGPoint p1 = [self makePointWithRaius:radius angle:hourAngle];
    UIBezierPath *path = UIBezierPath.bezierPath;
    [self.blackColor setStroke];
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 4;
    [path moveToPoint:self.center];
    [path addLineToPoint:p1];
    
    [path stroke];
}

- (void) drawMinuteHand: (CGFloat)minute {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat radius = MIN(size.width, size.height) / 2 - 70;
    
    CGFloat hourAngle = (minute / 60.0) * M_PI * 2 - 3 * 5 * self.angleUnit;
    
    CGPoint p1 = [self makePointWithRaius:radius angle:hourAngle];
    UIBezierPath *path = UIBezierPath.bezierPath;
    [self.blackColor setStroke];
    path.lineWidth = 4;
    [path moveToPoint:self.center];
    [path addLineToPoint:p1];
    
    [path stroke];
}

- (void) drawSecondHand: (CGFloat)second {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat radius = MIN(size.width, size.height) / 2 - 34;
    
    CGFloat hourAngle = (second / 60.0) * M_PI * 2 - 3 * 5 * self.angleUnit;
    
    CGPoint p1 = [self makePointWithRaius:radius angle:hourAngle];
    CGPoint p2 = [self makePointWithRaius:20 angle:hourAngle + M_PI];
    UIBezierPath *path = UIBezierPath.bezierPath;
    [UIColor.redColor setStroke];
    path.lineWidth = 1;
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    
    [path stroke];
}

- (void)drawNumbers {
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat radius = MIN(size.width, size.height) / 2 - 54;
    
    for(int i=1; i<=12; i++) {
        CGPoint p = [self makePointWithRaius:radius angle:(i - 3) * 5 * self.angleUnit];
        NSDictionary *font = @{
                               NSFontAttributeName: [UIFont boldSystemFontOfSize:24]
                               };
        NSString *numStr = [NSString stringWithFormat:@"%d", i];
        
        CGSize stringSize = [numStr sizeWithAttributes:font];
        
        p = CGPointMake(p.x - stringSize.width / 2, p.y - stringSize.height / 2);
        [numStr drawAtPoint:p withAttributes:font];
    }
}
    
- (void)drawCircles {
    CGSize size = UIScreen.mainScreen.bounds.size;
    
    CGFloat radius = MIN(size.width, size.height) / 2 - 10;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [self.blackColor setStroke];
    path.lineWidth = OUTER_LINE_WIDTH;
    [path stroke];
    
    path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius - 8 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [UIColor.grayColor setStroke];
    path.lineWidth = INNER_LINE_WIDTH;
    
    [path stroke];
}
    
- (void)drawTicks {
    CGSize size = UIScreen.mainScreen.bounds.size;
    
    UIBezierPath *longTickPath = UIBezierPath.bezierPath;
    UIBezierPath *shortTickPath = UIBezierPath.bezierPath;
    longTickPath.lineWidth = LONG_TICK_WIDTH;
    shortTickPath.lineWidth = SHORT_TICK_WIDTH;
    [self.blackColor setStroke];
    

    for(int i=0; i<60; i++) {
        CGFloat angle = self.angleUnit * i;
        CGFloat radius = MIN(size.width, size.height) / 2 - 24;
        
        BOOL isLongTick = i % 5 == 0;
        
        UIBezierPath *path = isLongTick ? longTickPath : shortTickPath;
        
        CGPoint p1 = [self makePointWithRaius:radius angle:angle];
        
        radius -= isLongTick ? LONG_TICK_LENGTH : SHORT_TICK_LENGTH;
        CGPoint p2 = [self makePointWithRaius:radius angle:angle];
        
        [path moveToPoint:p1];
        [path addLineToPoint:p2];
        
        [path stroke];
    }
}

- (CGPoint)makePointWithRaius: (CGFloat)radius angle: (CGFloat)angle {
    CGFloat x = self.center.x + radius * cos(angle);
    CGFloat y = self.center.y + radius * sin(angle);
    return CGPointMake(x, y);
}

- (CGFloat)angleUnit {
    return M_PI * 2 / 60;
}

- (UIColor *)blackColor {
    return [UIColor colorWithRed:0.01 green:0.01 blue:0.03 alpha:1];
}
    
@end

