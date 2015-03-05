//
//  PaperBuble.m
//  ProductTour
//
//  Created by mukesh mandora on 27/02/15.
//  Copyright (c) 2015 Clément Raussin. All rights reserved.
//

#import "PaperBuble.h"
#define CR_ARROW_SIZE 20
#import "CustomShapeView.h"
@implementation PaperBuble


-(id)initWithFrame:(CGRect)frame withAttachedView:(UIView *)nibName{
    self = [super init];
    if (self) {
        // Initialization code
        
        self.frame = frame;
        self.button1=nibName;
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 18, self.frame.size.width, self.frame.size.height-20) style:UITableViewStylePlain];
        _tableView.backgroundColor= [UIColor whiteColor];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.layer.shadowRadius = 10;
        _tableView.layer.shadowOpacity = 1.0;
        self.tableView.clipsToBounds = NO;
        self.tableView.layer.masksToBounds = NO;
        _tableView.layer.shadowColor=[UIColor blackColor].CGColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor=[UIColor lightGrayColor];

        [self addSubview:_tableView];
        self.backgroundColor=[UIColor clearColor];
        
        // Drawing code
        
        self.customShapeView=[[CustomShapeView alloc] initWithFrame:CGRectMake(self.button1.center.x-20, 0, 20, 20)];
        self.customShapeView.layer.borderWidth = 1.0;
        self.customShapeView.backgroundColor=[UIColor whiteColor];
        self.customShapeView.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:self.customShapeView];
        
        
        UIPanGestureRecognizer *stretch=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(strectBezierPath:)];
        stretch.delegate=self;
        [self.tableView addGestureRecognizer:stretch];
     
        _snap=[[UIView alloc] init];
        _snap=[self snapshotViewAfterScreenUpdates:YES];
        NSLog(@"Snap Shot%@",_snap);
       
        _tableView.alpha=0;
        _customShapeView.alpha=0;
        
    }
    return self;
}

-(void)strectBezierPath:(UIPanGestureRecognizer *)recognizer{
  
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint vel = [recognizer velocityInView:recognizer.view];
    CGFloat diff=CR_ARROW_SIZE;
    
    recognizer.view.center=CGPointMake(recognizer.view.center.x, recognizer.view.center.y+ translation.y);
 
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
   

    diff=self.tableView.frame.origin.y-diff;
    
    CGFloat fraction = (translation.y *M_PI_2 / recognizer.view.frame.size.height);
//    fraction = fminf(fmaxf(fraction, 0.0), 1.0);
    NSLog(@"%f %f",fraction,diff);
    
    if(diff>=0 && diff <30){
        
        if(vel.y>0){
            self.superview.center=CGPointMake(self.superview.center.x, self.superview.center.y+ translation.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];

        }
        
        _customShapeView.alpha=1.0;
        _customShapeView.frame=CGRectMake(self.button1.center.x-20, 0, CR_ARROW_SIZE, CR_ARROW_SIZE+diff);
        NSLog(@"Custom bounds %@",_customShapeView);
        

    }
    
    else{
        [UIView animateWithDuration:0.1 animations:^{
             _customShapeView.frame=CGRectMake(self.button1.center.x-20, CR_ARROW_SIZE+diff, CR_ARROW_SIZE, 0);
               self.superview.frame=CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
            
        } completion:nil];
         _customShapeView.alpha=0.0;
        if(recognizer.state==UIGestureRecognizerStateEnded){
        
//             [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
            [self pushBubble];
            
        }
//        [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//            
//        } completion:^(BOOL finished) {
//
//        }];
       
        
       
    }
   

    
    if(fraction*100 >=1){
//        [self pushBubble];
       
        
    }
    
}



-(void)pushBubble{
    
    _snap=[self snapshotViewAfterScreenUpdates:YES];
    [self addSubview:_snap];
    NSLog(@"%@",_snap);

    
//    CGRect shrunkenFrame = CGRectMake(self.button1.center.x, self.button1.center.y+20, 0, 0);
    CGRect shrunk=CGRectMake(self.button1.center.x, 0, 0, 0);
    
    _snap.alpha=1;
     self.tableView.alpha=0;
    _customShapeView.alpha=0;
    // animate with keyframes
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         
                        
                         _snap.frame=shrunk;
//                          self.superview.layer.transform = CATransform3DIdentity;
                                             }
                     completion:^(BOOL finished){
                         CABasicAnimation* scaleDown2 = [CABasicAnimation animationWithKeyPath:@"transform"];
                         scaleDown2.duration = 0.2;
                         scaleDown2.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1.15)];
                         scaleDown2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
                         [self.button1.layer addAnimation:scaleDown2 forKey:nil];
                         [self removeFromSuperview];
                         
                         
                     }];
}

-(void)popBubble{
    
   
//    CGRect shrunkenFrame = CGRectMake(self.button1.center.x-10, 0, 0, 0);
//    CGRect tabshrunken = CGRectMake(self.button1.center.x,20, 0, 0);
//   
//    CGRect fromFinalFrame =self.customShapeView.frame ;
//    
//    CGRect tabfinal=self.tableView.frame;
//    self.customShapeView.frame=shrunkenFrame;
//    self.tableView.frame=tabshrunken;
    
    [self addSubview:_snap];
    CGRect shrunk=CGRectMake(self.button1.center.x, 0, 0, 0);
    
    CGRect final=_snap.frame;
    _snap.frame=shrunk;
   
    NSLog(@"%f",self.tableView.frame.origin.x);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
       
       
//       // Move destination snapshot back in Z plane
//       CATransform3D perspectiveTransform = CATransform3DIdentity;
//       perspectiveTransform.m34 = 1.0 / -1000.0;
//       perspectiveTransform = CATransform3DTranslate(perspectiveTransform, 0, 0, -30);
//       self.superview.layer.transform = perspectiveTransform;
      
       _snap.frame=final;
//       self.customShapeView.frame=fromFinalFrame;
//       self.tableView.frame=tabfinal;
//       self.tableView.frame=tabfinal;
      
       
       
//        self.alpha=1;
       
       
       

   } completion:^(BOOL finished) {
       
       [self.snap setAlpha:0.0];
     
//        [self setNeedsDisplayInRect:self.frame];
       self.tableView.alpha=1;
       self.customShapeView.alpha=1;

      
   }];
    
    
  
}


-(void)updateArrow{
    
    // Drawing code
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    CGPoint startPoint = CGPointMake(self.button1.center.x, 0);
//    CGPoint thirdPoint = CGPointMake(self.button1.center.x-10, 0+20);
//    CGPoint endPoint = CGPointMake(self.button1.center.x+10, 0+20);
//    
//    
//    
//    NSLog(@"%@ %@ %@",NSStringFromCGPoint(startPoint),NSStringFromCGPoint(thirdPoint),NSStringFromCGPoint(endPoint));
//    path = [UIBezierPath bezierPath];
//    [path moveToPoint:startPoint];
//    [path addLineToPoint:endPoint];
//    [path addLineToPoint:thirdPoint];
//    //        [path moveToPoint:startPoint];
//    [path addLineToPoint:startPoint];
//   
//   
//    [self.layer addSublayer:_shapeLayer];
//    
//    
//
//        [UIView animateWithDuration:0.5 delay:3.0 options:0 animations:^{
//            
//            [UIView transitionWithView:self duration:0.2
//                               options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
//                
//                animation.fromValue = (id)_shapeLayer.path;
//                animation.toValue =  (__bridge id)([path CGPath]);
//                animation.duration = 0.3;
//                animation.removedOnCompletion=YES;
//                [_shapeLayer addAnimation:animation forKey:nil];
//                _shapeLayer.path=[path CGPath];
//            } completion:^(BOOL finished) {
//                
//            }];
//            
//
//        } completion:^(BOOL finished) {
//             [self setNeedsDisplay];
//            
//
//        }];
    
    [UIView animateWithDuration:0.5 animations:^{
       _customShapeView.frame=CGRectMake(self.button1.center.x-20, 0, 20, 20);
    } completion:^(BOOL finished) {
        
    }];
    
   
    
   

}


@end
