//
//  ContactActivityTouchView.h
//  Lianxi
//
//  Created by yang on 15/8/17.
//  Copyright (c) 2015年 TIXA. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContactActivityTouchViewDelegate;
@interface ContactActivityTouchView : UIView

@property (nonatomic, strong)   UIButton            *praiseButton;
@property (nonatomic, strong)   UIButton            *commentButton;
@property (nonatomic, weak)     id <ContactActivityTouchViewDelegate>   delegate;

- (NSIndexPath *)indexPathOfTableView:(UITableView *)tableView withTouches:(NSSet *)touches;

@end
@protocol ContactActivityTouchViewDelegate<NSObject>
- (void)contactActivityTouchView:(ContactActivityTouchView *)contactActivityTouchView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)contactActivityTouchView:(ContactActivityTouchView *)contactActivityTouchView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
