//
//  UPNEditListViewController.m
//  Up Next
//
//  Created by Jason Lotito on 8/2/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNEditListViewController.h"
#import "UPNAddSpeakerViewController.h"
#import "UPNSpeakerListModel.h"

@interface UPNEditListViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonAdd;
@property (strong, nonatomic) UPNSpeakerListModel *model;
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UITextField *inputField;
@end

@implementation UPNEditListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
                
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UPNAddSpeakerViewController *inputVC = segue.destinationViewController;
    
    inputVC.cancelHandler = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    inputVC.saveHandler = ^(NSString *name) {
        NSUInteger row = [self.model addSpeaker:name];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.model = [UPNSpeakerListModel sharedInstance];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // self.editing = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    [self createInputAccessoryView];
    [self.inputField becomeFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.inputField.inputAccessoryView = self.inputView;
}

-(void)createInputAccessoryView
{
//    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
//    self.inputView.backgroundColor = [UIColor redColor];
    self.inputField = [[UITextField alloc]initWithFrame:CGRectMake(110, 0, 100, 44)];
//    self.inputView.hidden = YES;
    [self.view addSubview:self.inputView];
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    btn.titleLabel.text = @"asdf";
//    [self.inputView addSubview:btn];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.model count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                             
    cell.textLabel.text = [self.model speakerNameAtIndex:indexPath.row];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model removeSpeakerAtIndex:indexPath.row];
        [self.model save];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)    tableView:(UITableView *)tableView
   moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
          toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *stringToMove = [self.model speakerNameAtIndex:fromIndexPath.row];
    [self.model removeSpeakerAtIndex:fromIndexPath.row];
    [self.model addSpeaker:stringToMove atIndex:toIndexPath.row];
    [self.model save];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
