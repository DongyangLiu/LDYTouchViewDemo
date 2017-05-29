//
//  ContactActivityTouchView.m
//  Lianxi
//
//  Created by yang on 15/8/17.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import "ContactActivityTouchView.h"
#define ICON_SIZE   (74.0 / 2.0)
@interface ContactActivityTouchView()<UIGestureRecognizerDelegate>
@property (nonatomic, assign)   CGPoint                         basePoint;
@property (nonatomic, strong)   UIImageView                     *baseImageView;
@property (nonatomic, strong)   UILongPressGestureRecognizer    *longPressGestureRecognizer;
@property (nonatomic, strong)   UISwipeGestureRecognizer        *swipeGestureRecognizer;
@property (nonatomic, strong)   UIPanGestureRecognizer          *panGestureRecognizer;
@property (nonatomic, assign)   BOOL                            longPressed;
@property (nonatomic, assign)   BOOL                            isCreateContent;
@property (nonatomic, assign)   BOOL                            isShow;
@property (nonatomic, strong)   UIView                          *backGroundView;
@property (nonatomic, strong)   UIImageView                     *praiseImageView;

@end
@implementation ContactActivityTouchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect rect = [[[UIApplication sharedApplication] delegate] window].bounds;
        rect.origin.y = 64;
        rect.size.height -= 64;
        self.frame = rect;
        [self refeshBackGroundView];
    }
    return self;
}
#pragma mark - views
- (void)refeshBackGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, self.frame.size.width, self.frame.size.height + 64)];
        [self addSubview:_backGroundView];
        [self sendSubviewToBack:_backGroundView];
    }
    if (_isShow) {
        _backGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }else{
        _backGroundView.backgroundColor = [UIColor clearColor];
    }
    
}
- (void)createContentViews
{
    [self createBaseView];
    [self createPraiseButton];
    [self createCommentButton];
    [self contentViewsDoAnimation];
    [self createPraiseImageView];
    _isCreateContent = YES;
}
- (void)removeContentViews
{
    if (_baseImageView) {
        [_baseImageView removeFromSuperview];
        _baseImageView = nil;
    }
    if (_praiseButton) {
        [_praiseButton removeFromSuperview];
        _praiseButton = nil;
    }
    if (_commentButton) {
        [_commentButton removeFromSuperview];
        _commentButton = nil;
    }
    if (_praiseImageView) {
        [_praiseImageView removeFromSuperview];
        _praiseImageView = nil;
    }
    _isCreateContent = NO;
}
- (void)createBaseView
{
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ICON_SIZE, ICON_SIZE)];
        _baseImageView.backgroundColor = [UIColor clearColor];
        _baseImageView.layer.cornerRadius = _baseImageView.frame.size.width / 2.0;
        _baseImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _baseImageView.layer.borderWidth = 1.0;
        _baseImageView.layer.masksToBounds = YES;
        _baseImageView.center = _basePoint;
    }
    [self addSubview:_baseImageView];
}
- (void)createPraiseButton
{
    if (!_praiseButton) {
        _praiseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ICON_SIZE, ICON_SIZE)];
        [_praiseButton setImage:[UIImage imageNamed:@"activity_praise_image_selected"] forState:UIControlStateSelected];
        [_praiseButton setImage:[UIImage imageNamed:@"activity_praise_image"] forState:UIControlStateNormal];
        _praiseButton.center = _basePoint;
    }
    [self addSubview:_praiseButton];
}
- (void)createCommentButton
{
    if (!_commentButton) {
        _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ICON_SIZE, ICON_SIZE)];
        [_commentButton setImage:[UIImage imageNamed:@"activity_comment_image_selected"] forState:UIControlStateSelected];
        [_commentButton setImage:[UIImage imageNamed:@"activity_comment_image"] forState:UIControlStateNormal];
        _commentButton.center = _basePoint;
    }
    [self addSubview:_commentButton];
}
- (void)createPraiseImageView
{
    if (!_praiseImageView) {
        _praiseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ICON_SIZE, ICON_SIZE)];
        [_praiseImageView setImage:[UIImage imageNamed:@"activity_praise_image_selected"]];
        [self addSubview:_praiseImageView];
        _praiseImageView.hidden = YES;
    }
}
- (void)animationPraiseImageView
{
    _praiseImageView.center = _praiseButton.center;

    _praiseImageView.hidden = NO;
    _praiseImageView.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        _praiseImageView.alpha = 0.0;
        _praiseImageView.center = CGPointMake(_praiseImageView.center.x, _praiseButton.center.y - 50);
    } completion:^(BOOL finished) {
        [self refeshBackGroundView];
        [self removeContentViews];
    }];
}
#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _longPressed = YES;
    _basePoint = point;
    [self performSelector:@selector(longPress) withObject:nil afterDelay:0.1];
    if ([_delegate respondsToSelector:@selector(contactActivityTouchView:touchesBegan:withEvent:)]) {
        [_delegate contactActivityTouchView:self touchesBegan:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    _isShow = NO;
    _longPressed = NO;
    BOOL isPraised = NO;
    if ([_delegate respondsToSelector:@selector(contactActivityTouchView:touchesEnded:withEvent:)]) {
        [_delegate contactActivityTouchView:self touchesEnded:touches withEvent:event];
    }
    if (!isPraised  && _praiseButton.isSelected) {
        [self animationPraiseImageView];
    }else{
        [self refeshBackGroundView];
        [self removeContentViews];
    }
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _longPressed = NO;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_longPressed) {
        if (_isCreateContent) {
            
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            CGFloat distanceComment = [self distanceFromPointX:point distanceToPointY:_commentButton.center];
            CGFloat distancePrise = [self distanceFromPointX:point distanceToPointY:_praiseButton.center];
            _praiseButton.selected = NO;
            _commentButton.selected = NO;
            if (distancePrise < 60 && distancePrise < distanceComment) {
                _praiseButton.selected = YES;
            }
            if (distanceComment < 60 && distanceComment < distancePrise) {
                _commentButton.selected = YES;
            }
        }else{
            _longPressed = NO;
        }
    }
}
- (void)longPress
{
    if (_longPressed) {
        _isShow = YES;
        [self refeshBackGroundView];
        [self createContentViews];
    }
}
#pragma mark - points
-(CGFloat)distanceFromPointX:(CGPoint)start distanceToPointY:(CGPoint)end{
    CGFloat distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt(pow(xDist, 2) + pow(yDist, 2));
    return distance;
}
- (void)contentViewsDoAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    CGFloat pointX = _basePoint.x + ((_basePoint.x >= self.frame.size.width / 2.0) ? -1 : 1) * 80 * sin(15 / 180.0 * M_PI);
    CGFloat pointY = _basePoint.y + ((_basePoint.x >= self.frame.size.width / 2.0) ? -1 : -1) * 80 *cos(15 / 180.0 * M_PI);
    _praiseButton.center = CGPointMake(pointX, pointY);
    
    pointX = _basePoint.x + ((_basePoint.x >= self.frame.size.width / 2.0) ? -1 : 1) * 80 * sin(75 / 180.0 * M_PI);
    pointY = _basePoint.y + ((_basePoint.x >= self.frame.size.width / 2.0) ? -1 : -1) * 80 *cos(75 / 180.0 * M_PI);
    _commentButton.center = CGPointMake(pointX, pointY);
    [UIView commitAnimations];
    
}
- (NSIndexPath *)indexPathOfTableView:(UITableView *)tableView withTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint tPoint = [self convertPoint:point toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:tPoint];
    return indexPath;
}
@end
