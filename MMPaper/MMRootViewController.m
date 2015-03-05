//
//  MMRootViewController.m
//  MMPaper
//
//  Created by mukesh mandora on 04/03/15.
//  Copyright (c) 2015 com.muku. All rights reserved.
//

#import "MMRootViewController.h"
#import "MMBaseCollection.h"
#import "MMSmallLayout.h"
#import "MMLargeLayout.h"
#import "PaperBuble.h"
@interface MMRootViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    BOOL toogle;
    PaperBuble *bubble;
    UIImageView *addfrd,*noti,*msg;
}
@property (nonatomic) MMBaseCollection *baseController;
@property (nonatomic, assign) NSInteger slide;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *topImage;
@property (nonatomic, strong) UIImageView *reflected;
@property (nonatomic, strong) NSArray *galleryImages;
@end

@implementation MMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     toogle=YES;
    // Do any additional setup after loading the view.
    MMSmallLayout *smallLayout = [[MMSmallLayout alloc] init];
    self.baseController=[[MMBaseCollection alloc] initWithCollectionViewLayout:smallLayout];
    
    
    [self.view addSubview:self.baseController.collectionView];
    
    _galleryImages = @[@"one.jpg", @"two.jpg", @"three.png", @"five.jpg", @"one.jpg"];
    _slide = 0;
    self.recipes=@[@""];
    
    // Init mainView
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 4;
    [self.view insertSubview:_mainView belowSubview:self.baseController.collectionView];
    
    // ImageView on top
    _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UIAppDelegate.itemHeight-256)];
    _reflected = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topImage.bounds), self.view.frame.size.width, self.view.frame.size.height/2)];
    [_mainView addSubview:_topImage];
    [_mainView addSubview:_reflected];
    
    _topImage.contentMode=UIViewContentModeScaleAspectFill;
    //_reflected.contentMode=UIViewContentModeScaleAspectFill;
    
    
    // Reflect imageView
    _reflected.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _topImage.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                        (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_topImage.layer insertSublayer:gradient atIndex:0];
    
    
    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = _reflected.bounds;
    gradientReflected.colors = @[(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor],
                                 (id)[[UIColor colorWithWhite:0 alpha:0] CGColor]];
    [_reflected.layer insertSublayer:gradientReflected atIndex:0];
    
    
    // Content perfect pixel
    UIView *perfectPixelContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_topImage.bounds), 1)];
    perfectPixelContent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [_topImage addSubview:perfectPixelContent];
    
    
    // Label logo
    UILabel *logo = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 0)];
    logo.backgroundColor = [UIColor clearColor];
    logo.textColor = [UIColor whiteColor];
    logo.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    logo.text = @"MMPaper";
    [logo sizeToFit];
    // Label Shadow
    [logo setClipsToBounds:NO];
    [logo.layer setShadowOffset:CGSizeMake(0, 0)];
    [logo.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [logo.layer setShadowRadius:1.0];
    [logo.layer setShadowOpacity:0.6];
    [_mainView addSubview:logo];
    
    
    // Label Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, logo.frame.origin.y + CGRectGetHeight(logo.frame) + 8, 290, 0)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    title.text = @"Mukesh Mandora";
    [title sizeToFit];
    // Label Shadow
    [title setClipsToBounds:NO];
    [title.layer setShadowOffset:CGSizeMake(0, 0)];
    [title.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [title.layer setShadowRadius:1.0];
    [title.layer setShadowOpacity:0.6];
    [_mainView addSubview:title];
    
    
    // Label SubTitle
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, title.frame.origin.y + CGRectGetHeight(title.frame), 290, 0)];
    subTitle.backgroundColor = [UIColor clearColor];
    subTitle.textColor = [UIColor whiteColor];
    subTitle.font = [UIFont fontWithName:@"Helvetica" size:13];
    subTitle.text = @"Inspired from Paper by Facebook";
    subTitle.lineBreakMode = NSLineBreakByWordWrapping;
    subTitle.numberOfLines = 0;
    [subTitle sizeToFit];
    // Label Shadow
    [subTitle setClipsToBounds:NO];
    [subTitle.layer setShadowOffset:CGSizeMake(0, 0)];
    [subTitle.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [subTitle.layer setShadowRadius:1.0];
    [subTitle.layer setShadowOpacity:0.6];
    [_mainView addSubview:subTitle];
    
    
    // First Load
    [self changeSlide];
    
    // Loop gallery - fix loop: http://bynomial.com/blog/?p=67
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(changeSlide) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setBackgroundImage:[UIImage imageNamed:@"Tones-50"] forState:UIControlStateNormal];
//    [button addTarget:self
//               action:@selector(aMethod:)
//     forControlEvents:UIControlEventTouchUpInside];
////    [button setTitle:@"Show View" forState:UIControlStateNormal];
//    button.frame = CGRectMake(180.0, 12, 25, 25);
//    
//    button.tintColor=[UIColor whiteColor];
//    [self.view addSubview:button];
    
    
     noti=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 20, 25, 25)];
    noti.image=[[UIImage imageNamed:@"Tones-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
     noti.tintColor=[UIColor whiteColor];
    [noti setUserInteractionEnabled:YES];
    [self.view addSubview:noti];
    
     addfrd=[[UIImageView alloc] initWithFrame:CGRectMake(noti.frame.origin.x-50, 20, 25, 25)];
    addfrd.image=[[UIImage imageNamed:@"Group-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    addfrd.tintColor=[UIColor whiteColor];
    [addfrd setUserInteractionEnabled:YES];
    [self.view addSubview:addfrd];
    
     msg=[[UIImageView alloc] initWithFrame:CGRectMake(addfrd.frame.origin.x-50, 20, 25, 25)];
    msg.image=[[UIImage imageNamed:@"Talk-50"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    msg.tintColor=[UIColor whiteColor];
    [msg setUserInteractionEnabled:YES];
    [self.view addSubview:msg];
    
    UITapGestureRecognizer *tapNoti=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubble:)];
    [noti addGestureRecognizer:tapNoti];
    tapNoti.delegate=self;
    
    noti.tag = 1;
    
    UITapGestureRecognizer *tapFrd=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubble:)];
    [addfrd addGestureRecognizer:tapFrd];
     tapFrd.delegate=self;
    addfrd.tag = 2;

    
    UITapGestureRecognizer *tapChat=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubble:)];
    [msg addGestureRecognizer:tapChat];
     tapChat.delegate=self;
    msg.tag = 3;

    
}


-(void)tapBubble:(UIGestureRecognizer *)sender{
    NSInteger tag=sender.view.tag;
    if(tag==1){
        [self toogleHelpAction:self];
    }
    else if (tag==2){
        [self actionBut2:self];
    }
    else{
        [self actionbut3:self];
    }
    
}




-(void)aMethod:(id)sender{
    NSLog(@"Hello");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
  
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Change slider
- (void)changeSlide
{
    //    if (_fullscreen == NO && _transitioning == NO) {
    if(_slide > _galleryImages.count-1) _slide = 0;
    
    UIImage *toImage = [UIImage imageNamed:_galleryImages[_slide]];
    [UIView transitionWithView:_mainView
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
                    animations:^{
                        _topImage.image = toImage;
                        _reflected.image = toImage;
                    } completion:nil];
    _slide++;
    //    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Bubble Action
- (IBAction)toogleHelpAction:(id)sender {
    if(bubble==nil && toogle==YES){
        toogle=NO;
        bubble=[[PaperBuble alloc] initWithFrame:CGRectMake(8, noti.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height) withAttachedView:noti];
        bubble.button1=noti;
        bubble.tableView.delegate=self;
        bubble.tableView.dataSource=self;
        [self.view addSubview:bubble];
        //        [bubble setAlpha:0.0];
        [bubble popBubble];
        
    }
    else{
        
        
        if(bubble.button1==noti){
            toogle=YES;
            [bubble pushBubble];
            bubble=nil;
        }
        else{
            bubble.button1=noti;
            [bubble updateArrow];
            [bubble.shapeLayer removeFromSuperlayer];
            
        }
        
        
        
        
    }
    
    [bubble.tableView reloadData];
}


- (IBAction)actionBut2:(id)sender {
    
    if(bubble==nil && toogle==YES){
        toogle=NO;
        bubble=[[PaperBuble alloc] initWithFrame:CGRectMake(8, addfrd.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height) withAttachedView:addfrd];
        bubble.button1=addfrd;
        bubble.tableView.delegate=self;
        bubble.tableView.dataSource=self;

        [self.view addSubview:bubble];
        [bubble popBubble];
        
    }
    else{
        
        
        if(bubble.button1==addfrd){
            toogle=YES;
            [bubble pushBubble];
            bubble=nil;
        }
        else{
            bubble.button1=addfrd;
            [bubble updateArrow];
            
        }
        
        
        
        
    }
    
    [bubble.tableView reloadData];
    
}

- (IBAction)actionbut3:(id)sender {
    if(bubble==nil && toogle==YES){
        toogle=NO;
        bubble=[[PaperBuble alloc] initWithFrame:CGRectMake(8, msg.center.y+20, self.view.frame.size.width-16, self.view.frame.size.height) withAttachedView:msg];
        bubble.button1=msg;
        bubble.tableView.delegate=self;
        bubble.tableView.dataSource=self;

        [self.view addSubview:bubble];
        [bubble popBubble];
        
    }
    else{
        
        
        if(bubble.button1==msg){
            toogle=YES;
            [bubble pushBubble];
            bubble=nil;
        }
        else{
            bubble.button1=msg;
            [bubble updateArrow];
            [bubble.shapeLayer removeFromSuperlayer];
        }
        
        
        
        
    }
    
    [bubble.tableView reloadData];
    
}

#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] init];
    [view setFrame:CGRectMake(0, 10, tableView.frame.size.width, 30)];
    [view setBackgroundColor:[UIColor whiteColor]];
    /* Create custom view to display section header... */
    
    unsigned colorInt = 0;
    [[NSScanner scannerWithString:@"0xe94c5e"] scanHexInt:&colorInt];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFrame:CGRectMake(18, 10, 300, 20)];
    label.textColor=[UIColor blackColor];
    label.font=[UIFont fontWithName:@"HelveticaNeue" size:20];
    
    if(bubble.button1==noti){
       label.text=@"Notification";
    }
    else if (bubble.button1==addfrd){
       label.text=@"Friend Request";
    }
    else{
       label.text=@"Chats";
    }
    
    label.textColor=[UIColor lightGrayColor];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    view.layer.cornerRadius = 5.0f;
    view.clipsToBounds = NO;
    view.layer.masksToBounds = NO;
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.recipes.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
//    cell.textLabel.text = [_recipes objectAtIndex:indexPath.row];
//    cell.textLabel.textColor=[UIColor blackColor];
    //    cell.backgroundColor=[UIColor blueColor];
    return cell;
    
}

@end
