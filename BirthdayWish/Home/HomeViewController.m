//
//  HomeViewController.m
//  AkilaBirthday
//
//  Created by Thangapandi M on 15/8/14.
//  Copyright (c) 2014 cognizant. All rights reserved.
//

#import "HomeViewController.h"
#import "JDFlipNumberView.h"
#import <SpriteKit/SpriteKit.h>
#import "ABUtility.h"
#import <AVFoundation/AVFoundation.h>
#import "ABUtility.h"

@interface HomeViewController () <JDFlipNumberViewDelegate>
{
    IBOutlet UIView *tapeViewContainer, *digitContainer, *cake1Container, *cardContainer, *cake2Container;
    IBOutlet UIImageView *leftDoor, *rightDoor, *tapeView, *cakeView1, *flameOnOff;
    IBOutlet UILabel *loginDesc, *wishDesc, *authorName, *currentWishCount;
    IBOutlet JDFlipNumberView *flipView1, *flipView2, *flipView3, *flipView4, *flipView5, *flipView6, *flipView7, *flipView8;
    IBOutlet SKView *skBGView;
    IBOutlet UIButton *blowBalloon;
    IBOutlet UITextView *wishDetail;
    
    
    NSTimer *timer;
    SystemSoundID soundID;
    AVAudioPlayer *_backgroundMusicPlayer;
    NSMutableArray *allFlipViews, *wishes;
    NSArray *loginDescData;
    BOOL isOpenDoorStarted;
    int doorAnimCount, randomDoorOpenCount, randomFlipNumber, currentWishIndex, blowAirCount;
}
@end

@implementation HomeViewController

-(void)roundedLabel:(UILabel *)label
{
    label.layer.cornerRadius = 3;
    label.alpha = 1;
}

-(void)blowAirAnimation
{
    UILabel *label1 = (UILabel *)[self.view viewWithTag:101];
    UILabel *label2 = (UILabel *)[self.view viewWithTag:102];
    UILabel *label3 = (UILabel *)[self.view viewWithTag:103];
    UILabel *label4 = (UILabel *)[self.view viewWithTag:104];
    
    [self roundedLabel:label1];
    [self roundedLabel:label2];
    [self roundedLabel:label3];
    [self roundedLabel:label4];
    
    float duration1 = 0.5 + (arc4random() % 5) / 10.0;
    float duration2 = 0.5 + (arc4random() % 5) / 10.0;
    float duration3 = 0.5 + (arc4random() % 5) / 10.0;
    float duration4 = 0.5 + (arc4random() % 5) / 10.0;
    
    float distance = 150;
    int diverse = 10;
    
    [UIView animateWithDuration:duration1 animations:^{
        label1.frame = CGRectMake(label1.frame.origin.x - distance, label1.frame.origin.y - (arc4random() % diverse), label1.frame.size.width, label1.frame.size.height);
        label1.alpha = 0;
    } completion:^(BOOL finished) {
        blowAirCount++;
        [self offTheCandle];
    }];
    
    [UIView animateWithDuration:duration2 animations:^{
        label2.frame = CGRectMake(label2.frame.origin.x - distance, label2.frame.origin.y - (arc4random() % diverse), label2.frame.size.width, label2.frame.size.height);
        label2.alpha = 0;
    } completion:^(BOOL finished) {
        blowAirCount++;
        [self offTheCandle];
    }];
    
    [UIView animateWithDuration:duration3 animations:^{
        label3.frame = CGRectMake(label3.frame.origin.x - distance, label3.frame.origin.y + (arc4random() % diverse), label3.frame.size.width, label3.frame.size.height);
        label3.alpha = 0;
    } completion:^(BOOL finished) {
        blowAirCount++;
        [self offTheCandle];
    }];
    
    [UIView animateWithDuration:duration4 animations:^{
        label4.frame = CGRectMake(label4.frame.origin.x - distance, label4.frame.origin.y + (arc4random() % diverse), label4.frame.size.width, label4.frame.size.height);
        label4.alpha = 0;
    } completion:^(BOOL finished) {
        blowAirCount++;
        [self offTheCandle];
    }];
}

-(void)offTheCandle
{
    if(blowAirCount == 2)
    {
        [flameOnOff stopAnimating];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSString *imageName;
        for(int i=1; i < 5; i++)
        {
            imageName = [NSString stringWithFormat:@"flameOff%d.png", i];
            [tempArray addObject:[UIImage imageNamed:imageName]];
        }
        flameOnOff.image = [UIImage imageNamed:@"flameOff4.png"];
        flameOnOff.animationDuration = 2.0;
        flameOnOff.animationImages = tempArray;
        flameOnOff.animationRepeatCount = 1;
        [flameOnOff startAnimating];
        [self bringUpWishCard];
    }
}

-(IBAction)blowBalloon:(UIButton *)sender
{
    blowAirCount = 0;
    [self blowAirAnimation];
    blowBalloon.enabled = NO;
//    [sender setHighlighted:YES];
}

-(void)changeWishContent
{
    wishDesc.text = [[wishes objectAtIndex:currentWishIndex] objectForKey:@"wish"];
    wishDetail.text = [[wishes objectAtIndex:currentWishIndex] objectForKey:@"wish"];
    NSString *author = [NSString stringWithFormat:@"- %@", [[wishes objectAtIndex:currentWishIndex] objectForKey:@"authorName"]];
    authorName.text = author;
    currentWishCount.text = [NSString stringWithFormat:@"%d of %d", currentWishIndex + 1, wishes.count];
}

-(IBAction)changeWish:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        if(currentWishIndex > 0)
        {
            currentWishIndex--;
            [self changeWishContent];
        }
    }
    else
    {
        if(currentWishIndex < wishes.count - 1)
        {
            currentWishIndex++;
            [self changeWishContent];
        }
    }
}

-(void)bringUpWishCard
{
    [UIView animateWithDuration:2.0 delay:3.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        cake2Container.frame = CGRectMake(0, -768, cake2Container.frame.size.width, cake2Container.frame.size.height);
//        cardContainer.frame = CGRectMake(0, 0, cardContainer.frame.size.width, cardContainer.frame.size.height);
        cake2Container.alpha = 0;
        cardContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [cake2Container removeFromSuperview];
        cake2Container = nil;
    }];
}

-(void)bringBalloon
{
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear  animations:^{
        blowBalloon.frame = CGRectMake(657, blowBalloon.frame.origin.y, blowBalloon.frame.size.width, blowBalloon.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)bringUpCake2
{
    float duration = 5.0;
//    duration = 1.0; //change
    [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionCurveEaseIn animations:^{
        cake1Container.frame = CGRectMake(0, -768, cake1Container.frame.size.width, cake1Container.frame.size.height);
        cake2Container.frame = CGRectMake(0, 0, cake2Container.frame.size.width, cake2Container.frame.size.height);
    } completion:^(BOOL finished) {
        [cake1Container removeFromSuperview];
        cake1Container = nil;
        [self bringBalloon];
    }];
}

-(void)bringUpCake1
{
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        cake1Container.transform = CGAffineTransformMakeScale(1, 1);
        cake1Container.alpha = 1;
    } completion:^(BOOL finished) {
        [self bringUpCake2];
        [flameOnOff startAnimating];
    }];
    

    
//    [UIView animateWithDuration:2.0 animations:^{
//        [cake1Container setFrame:CGRectMake(0, 10, cake1Container.frame.size.width, cake1Container.frame.size.height)];
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(void)setSmokeSpriteWithNumber:(int)spriteNumber
{
    if(spriteNumber == 1)
    {
        NSString *burstPath =
        [[NSBundle mainBundle] pathForResource:@"smokeTopLeft" ofType:@"sks"];
        
        SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        emitter.position = CGPointMake(0, 0);
//        emitter.position = CGPointMake(0, skBGView.frame.size.height);
        [[skBGView scene] addChild:emitter];
    }
    else if(spriteNumber == 2)
    {
        NSString *burstPath =
        [[NSBundle mainBundle] pathForResource:@"snow1" ofType:@"sks"];
        
        SKEmitterNode *emitter =  [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        emitter.position = CGPointMake(0, skBGView.frame.size.height);
        [[skBGView scene] addChild:emitter];
    }
}

-(void)flipNumberView:(JDFlipNumberView *)flipNumberView willChangeToValue:(NSUInteger)newValue
{
    AudioServicesPlaySystemSound(soundID);
}

-(void)flipNumberView:(JDFlipNumberView *)flipNumberView didChangeValueAnimated:(BOOL)animated
{
//    /System/Library/Audio/UISounds/RingerChanged.caf
    
    NSLog(@"");
    if(flipNumberView.value == 0)
    {
        JDFlipNumberView *flipView;
        for(int i=0; i < allFlipViews.count; i++)
        {
            flipView = [allFlipViews objectAtIndex:i];
            [flipView stopAnimation];
        }
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            [digitContainer setAlpha:0];
        }completion:^(BOOL finished) {
            [digitContainer removeFromSuperview];
            digitContainer = nil;
            [self setSmokeSpriteWithNumber:2];
            [_backgroundMusicPlayer play];    //balaji
            [self bringUpCake1];
        }];
    }
    else if(flipNumberView.value == 4)
    {
//        [self setSmokeSpriteWithNumber:1];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if([touch view] == tapeView)
    {
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if([touch view] == tapeViewContainer)
    {
        CGPoint location = [touch locationInView:tapeViewContainer];
        if(location.y > 180 && !isOpenDoorStarted)
        {
            if(doorAnimCount == randomDoorOpenCount)
            {
                isOpenDoorStarted = YES;
                doorAnimCount++;
                [self openDoor];
            }
            else
            {
                isOpenDoorStarted = YES;
                doorAnimCount++;
                [self openAndCloseDoor];
            }
        }
    }
}

-(void)showDigitContainerWithAnimation
{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        digitContainer.alpha = 1;
    } completion:^(BOOL finished) {
        for(int i=0; i < allFlipViews.count; i++)
        {
            JDFlipNumberView *flipView = [allFlipViews objectAtIndex:i];
            [flipView animateDownWithTimeInterval:1];
        }

    }];
}

-(void)openDoor
{
    [UIView animateWithDuration:2 animations:^{
        leftDoor.frame = CGRectMake(-512, leftDoor.frame.origin.y, leftDoor.frame.size.width, leftDoor.frame.size.height);
        
        rightDoor.frame = CGRectMake(256 * 4, rightDoor.frame.origin.y, rightDoor.frame.size.width, rightDoor.frame.size.height);
        
        tapeViewContainer.frame = CGRectMake(tapeViewContainer.frame.origin.x, -tapeViewContainer.frame.size.height, tapeViewContainer.frame.size.width, tapeViewContainer.frame.size.height);
        
        [loginDesc setAlpha:0];
        
        [self showDigitContainerWithAnimation];
        
    } completion:^(BOOL finished) {
        [leftDoor removeFromSuperview];
        [rightDoor removeFromSuperview];
        [tapeViewContainer removeFromSuperview];
        [loginDesc removeFromSuperview];
        
        leftDoor = nil;
        rightDoor = nil;
        tapeViewContainer = nil;
        loginDescData = nil;
    }];
}

-(void)openAndCloseDoor
{
    [UIView animateWithDuration:0.3 animations:^{
        leftDoor.frame = CGRectMake(-256, leftDoor.frame.origin.y, leftDoor.frame.size.width, leftDoor.frame.size.height);
        
        rightDoor.frame = CGRectMake(256 * 3, rightDoor.frame.origin.y, rightDoor.frame.size.width, rightDoor.frame.size.height);
        
    } completion:^(BOOL finished) {
        leftDoor.frame = CGRectMake(0, leftDoor.frame.origin.y, leftDoor.frame.size.width, leftDoor.frame.size.height);
        
        rightDoor.frame = CGRectMake(256 * 2, rightDoor.frame.origin.y, rightDoor.frame.size.width, rightDoor.frame.size.height);
        isOpenDoorStarted = NO;
        
        loginDesc.text = [loginDescData objectAtIndex:doorAnimCount];
    }];
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    
//    if([touch view] == boxView)
//    {
//        CATransition *animation = [CATransition animation];
//        [animation setDelegate:self];
//        [animation setDuration:.6];
//        animation.type = @"pageCurl";
//        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
//        {
//            animation.subtype = @"fromBottom";
//        }
//        [[boxView layer] addAnimation:animation forKey:@"NextProfile"];
//        
//        currentPid++;
//        if(currentPid < [wishesData count])
//        {
//            boxLabel.text = [wishesData objectAtIndex:currentPid];
//            //                selectedUid = [[tableData objectAtIndex:currentPid] valueForKey:@"Uid"];
//            
//            if((currentPid + 1) < [wishesData count])
//            {
//                boxLabel1.text = [wishesData objectAtIndex:currentPid + 1];
//            }
//            else
//            {
//                boxLabel1.text = [wishesData objectAtIndex:0];
//            }
//        }
//        else
//        {
//            if([wishesData count] > 0)
//            {
//                boxLabel.text = [wishesData objectAtIndex:0];
//                currentPid = 0;
//                
//                if([wishesData count] > 1)
//                {
//                    boxLabel1.text = [wishesData objectAtIndex:1];
//                }
//                else
//                {
//                    boxLabel1.text = [wishesData objectAtIndex:0];
//                }
//            }
//        }
//    }
//}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    crackView.frame = CGRectMake(crackView.frame.origin.x, -crackView.frame.size.height, crackView.frame.size.width, crackView.frame.size.height);
}

-(void)setDefaultValuesForFlipViews:(NSMutableArray *)flipViews
{
    JDFlipNumberView *flipView;
    for(int i=0; i < flipViews.count; i++)
    {
        flipView = [flipViews objectAtIndex:i];
        flipView.value = randomFlipNumber;
        flipView.digitCount = 1;
        NSLog(@"%d ---- %@", i+1, flipView);
        [flipView setFrame:CGRectMake(flipView.frame.origin.x, flipView.frame.origin.y, 120, 180)];
    }
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)prepareBirthdaySong
{
    NSError *error;
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"PianoHappyBirthday1" ofType:@"mp3"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:pewPewURL error:&error];
    _backgroundMusicPlayer.numberOfLoops = -1;
    [_backgroundMusicPlayer prepareToPlay];
}

-(void)prepareCake1Animation
{
    cakeView1.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"birthdayCake-1 (dragged).tiff"], [UIImage imageNamed:@"birthdayCake-2 (dragged).tiff"], nil];
    cakeView1.animationDuration = 0.5;
    [cakeView1 startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    tock -- /System/Library/Audio/UISounds/sq_tock.caf
//sms_alert_note.caf
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[NSURL URLWithString:@"/System/Library/Audio/UISounds/sq_tock.caf"],&soundID);
    
    isOpenDoorStarted = NO;
    doorAnimCount = 0;
    
    loginDescData = [NSArray arrayWithObjects:@"Please swipe to login", @"Swipe Properly", @"Can you try once again?", @"Oh.. Swipe the tape", nil];
    
    randomDoorOpenCount = (arc4random() % [loginDescData count]);
//    randomDoorOpenCount = 0;    //balaji
    
    randomFlipNumber = (arc4random() % 5) + 6;
//    randomFlipNumber = 1;   //balaji
    
    flipView1.delegate = self;
    allFlipViews = [[NSMutableArray alloc] init];
    [allFlipViews addObject:flipView1];
    [allFlipViews addObject:flipView2];
    [allFlipViews addObject:flipView3];
    [allFlipViews addObject:flipView4];
    [allFlipViews addObject:flipView5];
    [allFlipViews addObject:flipView6];
    [allFlipViews addObject:flipView7];
    [allFlipViews addObject:flipView8];
    
    [self setDefaultValuesForFlipViews:allFlipViews];
    
//    [self showDigitContainerWithAnimation];
    //85, 126

//    [self setSmokeSpriteWithNumber:2];
    
    SKScene *skScene = [SKScene sceneWithSize:skBGView.frame.size];
    skScene.scaleMode = SKSceneScaleModeAspectFill;
    skScene.backgroundColor = [UIColor clearColor];
    [skBGView presentScene:skScene];
    [skBGView scene];
    
    NSLog(@"%@", [[ABUtility readDataFromPlist:@"wishes"] objectForKey:@"wishes"]);
    
    [self prepareBirthdaySong];
    [self prepareCake1Animation];
    
    currentWishIndex = 0;
    wishes = [[ABUtility readDataFromPlist:@"wishes"] objectForKey:@"wishes"];
    
    [self changeWishContent];
    
    cake1Container.transform = CGAffineTransformMakeScale(0, 0);
    cake1Container.alpha = 0;
    
    [cardContainer setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSString *imageName;
    for(int i=1; i < 5; i++)
    {
        imageName = [NSString stringWithFormat:@"flameOn%d.png", i];
        [tempArray addObject:[UIImage imageNamed:imageName]];
    }
    flameOnOff.animationDuration = 0.2;
    flameOnOff.animationImages = tempArray;
    
    blowBalloon.frame = CGRectMake(1024, 189, blowBalloon.frame.size.width, blowBalloon.frame.size.height);
    
//    wishDetail.editable = YES;
//    wishDetail.textColor = [UIColor whiteColor];
//    wishDetail.font = [UIFont fontWithName:@"Superclarendon Light" size:40.0];
//    wishDetail.editable = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [flipView1 animateToPreviousNumber];
    
    wishDetail.editable = NO;
    wishDetail.selectable = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
