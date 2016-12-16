//
//  WishConsolidated.m
//  AkilaBirthday
//
//  Created by iNET Admin on 19/8/14.
//  Copyright (c) 2014 cognizant. All rights reserved.
//

#import "WishConsolidated.h"
#import "ABUtility.h"

@interface WishConsolidated ()
{
    IBOutlet UITableView *wishAuthors;
    IBOutlet UITextView *wishDesc;
    
    NSArray *wishes;
}

-(IBAction)dismissModal:(UIButton *)sender;

@end

@implementation WishConsolidated

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wishes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"authorName"];
    cell.textLabel.text = [[wishes objectAtIndex:indexPath.row] objectForKey:@"authorName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    wishDesc.text = [[wishes objectAtIndex:indexPath.row] objectForKey:@"wish"];
}

-(IBAction)dismissModal:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    // Do any additional setup after loading the view.
    
    wishes = [[ABUtility readDataFromPlist:@"wishes"] objectForKey:@"wishes"];
    
    wishAuthors.delegate = self;
    wishAuthors.dataSource = self;
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
