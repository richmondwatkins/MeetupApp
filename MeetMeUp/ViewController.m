//
//  ViewController.m
//  MeetMeUp
//
//  Created by Richmond on 10/13/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"
#import "DetailMeetupViewController.h"
@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *meetups;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property NSMutableArray *searchResults;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchResults = [[NSMutableArray alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=477d1928246a4e162252547b766d3c6d"]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.meetups = results[@"results"];
        [self.tableView reloadData];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == self.searchController.searchResultsTableView) {
        return self.searchResults.count;
    } else {
        return self.meetups.count;

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *meetup;

    static NSString *cellId = @"CellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];

    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        meetup = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        meetup = [self.meetups objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = meetup[@"name"];
    cell.detailTextLabel.text = meetup[@"venue"][@"address_1"];

    return  cell;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    for (NSDictionary *meetup in self.meetups) {
        if ([meetup[@"name"] containsString:searchText]) {
            [self.searchResults addObject:meetup];
        }
    }
}


-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchController.searchBar scopeButtonTitles] objectAtIndex:[self.searchController.searchBar selectedScopeButtonIndex]]];

return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    DetailMeetupViewController *detailCtrl = [[DetailMeetupViewController alloc] init];
//
//    if (self.searchDisplayController.searchResultsTableView) {
//        detailCtrl.meetup = [self.searchResults objectAtIndex:[self.tableView indexPathForSelectedRow].row];
//    } else {
//        detailCtrl.meetup = [self.meetups objectAtIndex:[self.tableView indexPathForSelectedRow].row];
//    }
//
//    [self.navigationController pushViewController:detailCtrl animated:YES];
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailMeetupViewController *detailCtrl = [segue destinationViewController];
    detailCtrl.meetup = [self.meetups objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
    if ([segue.identifier  isEqualToString:@"Detail"]) {
        if (self.searchDisplayController.active == YES) {
            NSIndexPath *indexPath = indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            detailCtrl.meetup = [self.searchResults objectAtIndex:indexPath.row];

        }
        else {
            NSIndexPath *indexPath = indexPath = [self.tableView indexPathForSelectedRow];
            detailCtrl.meetup = [self.meetups objectAtIndex:indexPath.row];
        }

    }
}




@end
