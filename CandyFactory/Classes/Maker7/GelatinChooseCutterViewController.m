//
//  GelatinChooseCutterViewController.m
//  CandyFactory
//
//  Created by Ana-Maria Stoica on 1/8/13.
//  Copyright (c) 2013 Ana-Maria Stoica. All rights reserved.
//

#import "GelatinChooseCutterViewController.h"
#import "GelatinfinalViewController.h"
#import "GelatinDecoratingViewController.h"
#import "AppDelegate.h"

@implementation GelatinChooseCutterViewController
@synthesize scroll;
@synthesize flavourRGB;
@synthesize isLocked;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (int i =0; i<18; i++) {
        
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *i, 0, [UIScreen mainScreen].bounds.size.height, scroll.frame.size.height)];
        view.userInteractionEnabled = YES;
         if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
             UIImageView * apple = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cutter%d.png",i+1]]];
             apple.frame = CGRectMake(0 , 40, 325, 309);
             apple.tag =i+1;
             UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickedView:)];
             tap.numberOfTapsRequired = 1;
             [apple addGestureRecognizer:tap];
             apple.userInteractionEnabled = YES;
             [view addSubview:apple];

         }
        else
        {
        UIImageView * apple = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"cutter%d-iPad.png",i+1]]];
        apple.frame = CGRectMake(0 , 40, 768, 730);
        apple.tag =i+1;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClickedView:)];
        tap.numberOfTapsRequired = 1;
        [apple addGestureRecognizer:tap];
        apple.userInteractionEnabled = YES;
        [view addSubview:apple];
        }
        if (!isLocked && i>3) {
           // view.userInteractionEnabled = NO;
            UIImageView *lockImageView = [[UIImageView alloc] init];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                lockImageView.frame = CGRectMake(10, 10, 251, 315);
                lockImageView.image = [UIImage imageNamed:@"lockFullSize~ipad.png"];
                
                // [selectButton setEnabled:NO];
            }
            else
            {
                lockImageView.frame = CGRectMake(0, -20, 106, 133);
                lockImageView.image = [UIImage imageNamed:@"lockFullSize.png"];
                
                //[selectButton setEnabled:NO];
            }
            [view addSubview:lockImageView];
        }
        
        [scroll addSubview:view];
        
    }
    scroll.contentSize = CGSizeMake(18*[UIScreen mainScreen].bounds.size.width,scroll.frame.size.height);
    scroll.userInteractionEnabled = YES;
    [self.scroll setContentOffset: CGPointMake(scroll.contentSize.width - 10*scroll.frame.size.width, 0) animated:NO];
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         self.scroll.contentOffset = CGPointMake(0, 0);
     } completion:^ (BOOL completed)
     {
         
     }];

    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)BackButtonPressed:(id)sender
{
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
   // [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        StoreViewController * store ;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            store = [[StoreViewController alloc]initWithNibName:@"StoreViewController-iPad" bundle:nil];
        }
        else
        {
            store = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
        }
        [self presentViewController:store animated:YES completion:nil];
        
        
        
    }
}
-(void)ClickedView:(UITapGestureRecognizer *)tap
{
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    NSString * treat;
    
     if (!isLocked && tap.view.tag>4)
     {
         
         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"This item is locked. Would you like to buy the Gelatin pack? This feature will unlock all items and remove ads in Gelatin maker!" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Go to Store", nil];
         [alert show];
     }
    else
    {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                treat = [NSString stringWithFormat:@"treat%.0f~ipad.png",self.scroll.contentOffset.x/768+1];
            }
            else
            {
                treat = [NSString stringWithFormat:@"treat%.0f.png",self.scroll.contentOffset.x/320+1];
            }
            
            GelatinDecoratingViewController * final;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                final = [[GelatinDecoratingViewController alloc]initWithNibName:@"GelatinDecoratingViewController-iPad" bundle:nil];
            }
            else {
                final = [[GelatinDecoratingViewController alloc]initWithNibName:@"GelatinDecoratingViewController" bundle:nil];
                
            }
            final.treatName = treat;
            final.flavourRGB = flavourRGB;
            [self.navigationController pushViewController:final animated:YES];
    }

}
-(IBAction)Next:(id)sender
{
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
  

    NSString * treat;
   
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          treat = [NSString stringWithFormat:@"treat%.0f~ipad.png",self.scroll.contentOffset.x/768+1];
     }
    else
    {
         treat = [NSString stringWithFormat:@"treat%.0f.png",self.scroll.contentOffset.x/320+1];
    }

    int a =  self.scroll.contentOffset.x/320+1;
    
     if (!isLocked && a>3) {
         UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"This item is locked. Would you like to buy the Gelatin pack? This feature will unlock all items and remove ads in Gelatin maker!" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Go to Store", nil];
         [alert show];
   
     }
    else
    {
        GelatinDecoratingViewController * final;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            final = [[GelatinDecoratingViewController alloc]initWithNibName:@"GelatinDecoratingViewController-iPad" bundle:nil];
        }
        else {
            final = [[GelatinDecoratingViewController alloc]initWithNibName:@"GelatinDecoratingViewController" bundle:nil];
            
        }
        final.treatName = treat;
        final.flavourRGB = flavourRGB;
        [self.navigationController pushViewController:final animated:YES];
    }
}

@end
