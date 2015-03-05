//
//  MMBaseCollection.m
//  MMPaper
//
//  Created by mukesh mandora on 26/12/14.
//  Copyright (c) 2014 com.muku. All rights reserved.
//

#import "MMBaseCollection.h"
#define MAX_COUNT 20
#define CELL_ID @"CELL_ID"
#import "HATransitionLayout.h"
#import "MMCollectionViewCell.h"
#import "POP.h"

@implementation MMBaseCollection


- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[MMCollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        toBeExpandedFlag=true;
        transitioningFlag=false;
        changedFlag=false;
        _smallLayout=[[MMSmallLayout alloc] init];
        _smallLayout=(MMSmallLayout*)layout;
        _largeLayout=[[MMLargeLayout alloc] init];
        [self gestureInit];
        
    }
    return self;
}

-(void)gestureInit{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.collectionView addGestureRecognizer:panGestureRecognizer];
    
     pichGestureRecogonizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.collectionView addGestureRecognizer:pichGestureRecogonizer];
    
    
    UITapGestureRecognizer *tapLayout=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLayout:)];
    [self.collectionView addGestureRecognizer:tapLayout];
    tapLayout.delegate=self;

    
    
}
-(void)changeLayout:(UITapGestureRecognizer*)sender{
    
    if(toBeExpandedFlag){
            [self.collectionView setCollectionViewLayout:_largeLayout animated:YES completion:nil];
        toBeExpandedFlag=NO;
 
    }
   
    
}
-(void)handlePan:(UIPanGestureRecognizer *)sender{
    
    
    CGPoint point = [sender locationInView:sender.view];
    CGPoint velocity = [sender velocityInView:sender.view];
    CGPoint translation = [sender translationInView:sender.view];
    //limit the range of velocity so that animation will not stop when verlocity is 0
    
    CGFloat yVelocity = (CGFloat)(MAX(MIN(ABS(velocity.y),80.0),20.0));
    
    CGFloat progress = ABS(point.y - initialPanPoint.y)/ABS(targetY - initialPanPoint.y);//MAX(MIN(ABS(point.y - initialPanPoint.y)/ABS(targetY - initialPanPoint.y),1.0),0.0);
    
//    if(abs(velocity.y) >  abs(velocity.x)) {
    
    
    
    if(sender.state==UIGestureRecognizerStateBegan){
        changedFlag = false;     //clear flag here
        if ([self getTransitionLayout ] ) {
            //animation is interrupted by user action
            //initialPoint.y and targetY has to be updated according to progress
            //and touched position
            
            [self updatePositionData:point withProgess:[self getTransitionLayout ].transitionProgress];
            
            return;
        }
        if ((velocity.y > 0 && toBeExpandedFlag) || (velocity.y < 0 && !toBeExpandedFlag)) {
            //only respond to one direction of swipe
            return;
        }
        
        initialPanPoint = point;    // record the point where gesture began
        
        CGFloat tallHeight = _largeLayout.itemSize.height;
        CGFloat shortHeight = _smallLayout.itemSize.height;
        
        CGFloat hRatio = (tallHeight - initialPanPoint.y) / (toBeExpandedFlag ? shortHeight : tallHeight);
        
        // when the touch point.y reached targetY, that meanas progress = 1.0
        // update targetY value
        
        targetY = tallHeight - hRatio * (toBeExpandedFlag ? tallHeight : shortHeight);
        

        
        [self.collectionView startInteractiveTransitionToCollectionViewLayout:(toBeExpandedFlag?_largeLayout:_smallLayout) completion:^(BOOL completed, BOOL finished) {
//            hasActiveInteraction=NO;
            [self startGesture];
            
        }];
        transitioningFlag = true;

    }
    else if (sender.state==UIGestureRecognizerStateCancelled || sender.state==UIGestureRecognizerStateEnded){
        if (!changedFlag) {//without this guard, collectionview behaves strangely
            
            return;
        }
        
       
        
//        [self stopGesture];
       
        if ([self getTransitionLayout]){
            
            
            
            BOOL success = [self getTransitionLayout].transitionProgress > 0.5;
            CGFloat yToReach;
            if (success) {
                 [self resetPopAnimation:sender.view];
                [self.collectionView finishInteractiveTransition];
                toBeExpandedFlag = !toBeExpandedFlag;

                yToReach = targetY;
              
            }
            else{
                 [self resetPopAnimation:sender.view];
                [self.collectionView cancelInteractiveTransition];
                yToReach = initialPanPoint.y;
                
               
            }
        }
        else{
          
            [self resetPopAnimation:sender.view];
        }
        

    }
    else if (sender.state==UIGestureRecognizerStateChanged){
        if (!transitioningFlag) {//if not transitoning, return
            return;
        }
        //            println("##changed")
        changedFlag = true ; // set flag here
        
        
        //update position only when point.y is between initialPoint.y and targety
        NSLog(@"%f", progress);
        if ((point.y - initialPanPoint.y) * (point.y - targetY) <= 0) {
            
           
            
        }
        if(progress<=1.1){
            [self updateWithProgress:progress];
        }
       
        else{
//            if(transitioningFlag){
//                POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//                anim.name = @"scale2x";
//                anim.springSpeed=5;
//                anim.springBounciness=1;
//                anim.toValue = [NSValue valueWithCGSize:CGSizeMake(progress, progress)];
//                
//                [sender.view pop_addAnimation:anim forKey:@"scale2x"];
//
//            }
          
           
        }

        
    }
    
   
    
//        }

}

-(void)resetPopAnimation:(UIView *)view{
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    anim.springBounciness = 0;
//    anim.springSpeed = 1;
//    
//    [view pop_addAnimation:anim forKey:@"scale"];
}

-(void)finishInteractiveTransition:(CGFloat)progress inDuration:(CGFloat)duration withSucess:(BOOL)success{
    if ((success && (progress >= 1.0)) || (!success && (progress <= 0.0))) {
        // no need to animate
        [self finishUpInteraction:success];
        
    }
    else{
//        [self updateWithProgress:[self getTransitionLayout].transitionProgress];
//        [self finishUpInteraction:success];
    }
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    
    if(gestureRecognizer == panGestureRecognizer) {
        
        
        UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan=(UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint direction = [pan velocityInView:pan.view];
        CGPoint pos = [pan locationInView:pan.view];
        
        //if touch point of out of range of cell, return false
        if (toBeExpandedFlag) {
            if(CGRectGetHeight(self.collectionView.frame) - _smallLayout.itemSize.height > pos.y) {
                return false;
            }
        }
        
        // if swipe for vertical direction, returns true
        
        if(abs(direction.y) >  abs(direction.x)) {
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return true;
    }
}



-(void)updatePositionData:(CGPoint)point withProgess:(CGFloat)progress{
    CGFloat tallHeight = _largeLayout.itemSize.height;
    CGFloat shortHeight = _smallLayout.itemSize.height;
    
    CGFloat itemHeight = (1-progress) * (toBeExpandedFlag ? shortHeight : tallHeight)
    + progress * (toBeExpandedFlag ? tallHeight : shortHeight);
    CGFloat hRatio = (_largeLayout.itemSize.height - point.y) / itemHeight;
    
    initialPanPoint.y = tallHeight - hRatio * (toBeExpandedFlag ? _smallLayout.itemSize.height:_largeLayout.itemSize.height);
    targetY = tallHeight - hRatio * (toBeExpandedFlag ? _largeLayout.itemSize.height:_smallLayout.itemSize.height);

}

-(UICollectionViewTransitionLayout *)getTransitionLayout{
    
//    UICollectionViewTransitionLayout *layout = [[UICollectionViewTransitionLayout alloc] init];
//    layout=(UICollectionViewTransitionLayout *)self.collectionView.collectionViewLayout;;
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[UICollectionViewTransitionLayout class]]) {
        return (UICollectionViewTransitionLayout *)self.collectionView.collectionViewLayout ;
    }
    else{
        return nil;
    }
}

-(void)updateWithProgress:(CGFloat)progress{
    //collectionViewLayout may be changed between flowLayout and transitionLayout
    //at any time. therefore, this guard is needed
   
    if ([self getTransitionLayout]){
        [self getTransitionLayout].transitionProgress = progress;
    }
}

-(void)startGesture{
    panGestureRecognizer.enabled=true;
}

-(void)stopGesture{
    panGestureRecognizer.enabled=false;
}

-(void)finishUpInteraction:(BOOL)success{
    if (!transitioningFlag) {
        return;
    }
    
    if (success) {
        [self updateWithProgress:1.0];
        [self.collectionView finishInteractiveTransition];
        transitioningFlag = false;
        toBeExpandedFlag = !toBeExpandedFlag;
    }
    else{
        [self updateWithProgress:0.0];
      
        [self.collectionView cancelInteractiveTransition];
        transitioningFlag = false;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return false;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Adjust scrollView decelerationRate
    self.collectionView.decelerationRate = self.class != [MMBaseCollection class] ? UIScrollViewDecelerationRateNormal : UIScrollViewDecelerationRateFast;
}

#pragma mark - Hide StatusBar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMCollectionViewCell *cell = (MMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.layer.cornerRadius = 4;
//    cell.clipsToBounds = YES;
//    
//    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
//    cell.backgroundView = backgroundView;
    [cell setIndex:indexPath.row withSize:(toBeExpandedFlag?_smallLayout.itemSize:_largeLayout.itemSize)];

    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX_COUNT;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}



- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView
                        transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    HATransitionLayout *transitionLayout = [[HATransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    return transitionLayout;
}

#pragma mark Gesture

-(void)handlePinch:(UIPinchGestureRecognizer *)sender{
    // here we want to end the transition interaction if the user stops or finishes the pinch gesture
     if (sender.state==UIGestureRecognizerStateCancelled || sender.state==UIGestureRecognizerStateEnded){
        
        
        if ([self getTransitionLayout]){
            
            
            
            BOOL success = [self getTransitionLayout].transitionProgress > 0.5;
            if (success) {
                [self resetPopAnimation:sender.view];
                [self.collectionView finishInteractiveTransition];
                toBeExpandedFlag = !toBeExpandedFlag;
                
            }
            else{
                [self resetPopAnimation:sender.view];
                [self.collectionView cancelInteractiveTransition];

            }
        }
        else{
            
            [self resetPopAnimation:sender.view];
        }
        
        
    }

    else if (sender.numberOfTouches == 2)
    {
        // here we expect two finger touch
        CGPoint point;      // the main touch point
        CGPoint point1;     // location of touch #1
        CGPoint point2;     // location of touch #2
        CGFloat distance;   // computed distance between both touches
        
        // return the locations of each gesture’s touches in the local coordinate system of a given view
        point1 = [sender locationOfTouch:0 inView:sender.view];
        point2 = [sender locationOfTouch:1 inView:sender.view];
        distance = sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
        
        // get the main touch point
        point = [sender locationInView:sender.view];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            
             changedFlag = false;
            // start the pinch in our out
            if (transitioningFlag)
            {
                self.initialPinchDistance = distance;
                self.initialPinchPoint = point;
                transitioningFlag= YES;    // the transition is in active motion
//                [self.delegate interactionBeganAtPoint:point];
                [self.collectionView startInteractiveTransitionToCollectionViewLayout:(toBeExpandedFlag?_largeLayout:_smallLayout) completion:^(BOOL completed, BOOL finished) {
                    //            hasActiveInteraction=NO;
                    [self startGesture];
                    
                }];
                
                
            }
        }
        
        if (transitioningFlag)
        {
            if (sender.state == UIGestureRecognizerStateChanged)
            {
                
                 changedFlag = true;
                // update the progress of the transtition as the user continues to pinch
                CGFloat delta = distance - self.initialPinchDistance;
                CGFloat offsetX = point.x - self.initialPinchPoint.x;
                //                CGFloat offsetY = point.y - self.initialPinchPoint.y;
                CGFloat offsetY = (point.y - self.initialPinchPoint.y) + delta/M_PI;
                UIOffset offsetToUse = UIOffsetMake(offsetX, offsetY);
                
                CGFloat distanceDelta = distance - self.initialPinchDistance;
                if (!toBeExpandedFlag)
                {
                    distanceDelta = -distanceDelta;
                }
                //                CGFloat dimension = sqrt(self.collectionView.bounds.size.width * self.collectionView.bounds.size.width + self.collectionView.bounds.size.height * self.collectionView.bounds.size.height);
                //                CGFloat progress = MAX(MIN((distanceDelta / dimension), 1.0), 0.0);
                CGFloat progress = MAX(MIN(((distanceDelta + sender.velocity * M_PI) / 250), 1.0), 0.0);
                
                // tell our UICollectionViewTransitionLayout subclass (transitionLayout)
                // the progress state of the pinch gesture
                //
                [self updateWithProgress:progress];
            }
        }
    }

}
@end
