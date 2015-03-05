//
//  PaperBuble.h
//  ProductTour
//
//  Created by mukesh mandora on 27/02/15.
//  Copyright (c) 2015 Clément Raussin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomShapeView.h"
@interface PaperBuble : UIView<UIGestureRecognizerDelegate>{
    CGFloat savedTrans;
   
}
@property (nonatomic, strong) UIView *button1;
@property (nonatomic) UITableView *tableView;
@property  (nonatomic) UIView *snap;
@property (nonatomic)  CAShapeLayer *shapeLayer,*startShapeLayer;
@property (nonatomic) CustomShapeView *customShapeView;
//-(id)initWithAttachedView:(UIView*)view withframe:(CGRect)rect;
-(void)popBubble;
-(void)pushBubble;
-(void)updateArrow;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(id)initWithFrame:(CGRect)frame withAttachedView:(UIView *)nibName;
@end
