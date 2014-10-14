//
//  DetailMeetupViewController.m
//  MeetMeUp
//
//  Created by Richmond on 10/13/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "DetailMeetupViewController.h"
#import "WebViewController.h"
@interface DetailMeetupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property NSArray *comments;
@property (strong, nonatomic) IBOutlet UILabel *rsvpsLabel;
@property (strong, nonatomic) IBOutlet UILabel *hostingLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DetailMeetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.meetup[@"name"];
    self.descriptionLabel.text = self.meetup[@"description"];
    NSNumber *rsvps = (NSNumber *) self.meetup[@"yes_rsvp_count"];
    self.rsvpsLabel.text = [NSString stringWithFormat:@"%d", [rsvps intValue]];
    self.hostingLabel.text = self.meetup[@"group"][@"name"];


    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&group_id=%@&page=20&key=477d1928246a4e162252547b766d3c6d", self.meetup[@"group"][@"id"]]]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.comments = results[@"results"];
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    NSDictionary *comment = [self.comments objectAtIndex:indexPath.row];

    cell.textLabel.numberOfLines = 0;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 20)];

    timeLabel.text = [self formatTime:comment[@"time"]];
    timeLabel.font= [timeLabel.font fontWithSize:10];

    [cell.contentView addSubview:timeLabel];

    cell.textLabel.text = comment[@"comment"];
    cell.detailTextLabel.text = comment[@"member_name"];


    return cell;
}



-(NSString *)formatTime:(NSNumber *)timeMil{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timeMil doubleValue] / 1000.0)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *resultString = [formatter stringFromDate:date];
    return resultString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    WebViewController *webCtrl = [segue destinationViewController];
    webCtrl.urlString = self.meetup[@"event_url"];
}

@end
