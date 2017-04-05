//
//  ChooseChocolateViewController.m
//  CandyFactory
//
//  Created by Ana-Maria Stoica on 12/10/12.
//  Copyright (c) 2012 Ana-Maria Stoica. All rights reserved.
//

#import "ChooseChocolateViewController.h"
#import "ChocolateBarsDragChocolateViewController.h"
#import "AppDelegate.h"



@implementation ChooseChocolateViewController
@synthesize scroll;
@synthesize isLocked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isLocked= NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
}
-(void)viewWillAppear:(BOOL)animated
{
    for (int i =0; i<10; i++) {
        UIButton * button = [[UIButton alloc]init];
        
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            if(i % 2 == 0)
                button.frame = CGRectMake(124, (i/2 )*200 +40, 198, 198);
            else button.frame = CGRectMake(446,  (i/2 )*200 +40, 198, 198);
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cunckMenuIcon%d-iPad.png",i+1]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cunckMenuIcon%d-iPad.png",i+1]] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cunckMenuIcon%d-iPad.png",i+1]] forState:UIControlStateHighlighted];
        }
        else{
            if (i%2 ==0) {
                button.frame = CGRectMake(50, (i/2 )*90 +20, 84, 84);
            }
            else button.frame = CGRectMake(184,  (i/2 )*90 +20, 84, 84);
            
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chunkMenuIcon%d.png",i+1]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chunkMenuIcon%d.png",i+1]] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chunkMenuIcon%d.png",i+1]] forState:UIControlStateHighlighted];
        }
        
        if(isLocked == NO)
        {
            if(i > 1)
            {
                UIImageView *lockImageView = [[UIImageView alloc] init];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    lockImageView.frame = CGRectMake(10, 10, 31, 40);
                    lockImageView.image = [UIImage imageNamed:@"lockStoreEverything-iPad.png"];
                    
                    //[button setEnabled:NO];
                }
                else
                {
                    lockImageView.frame = CGRectMake(10, 10, 31, 40);
                    lockImageView.image = [UIImage imageNamed:@"lockStoreEverything.png"];
                    
                    //[button setEnabled:NO];
                }
                [button addSubview:lockImageView];
            }
        }
        
        
        button.tag = i+1;
        [button addTarget:self action:@selector(Chocolatechoose:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:button];
        
        
    }
    scroll.contentSize = CGSizeMake(320, 5 * 300);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
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

-(void)Chocolatechoose:(UIButton*)sender
{
    if (sender.tag > 2 && !isLocked) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"This item is locked. Would you like to buy the ChocolateBars pack? This feature will unlock all items and remove ads in ChocolateBars maker!" delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Go to Store", nil];
        [alert show];

    }
    else
    {
 
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChoosedChocolate" object:sender];
    [self dismissViewControllerAnimated:YES completion:nil];
    }

}

-(IBAction)BackButtonPressed:(id)sender
{
   
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
