//
//  ProfileViewController.m
//  MeetMeUp
//
//  Created by Richmond on 10/13/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ProfileViewController.h"
@interface ProfileViewController () <UITableViewDataSource,UITableViewDelegate>
@property NSDictionary *profileInfo;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *topics;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=477d1928246a4e162252547b766d3c6d", self.userInfo[@"member_id"]]]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.profileInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", self.profileInfo);
        self.nameLabel.text = self.profileInfo[@"name"];
        self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", self.profileInfo[@"city"], self.profileInfo[@"country"]];
        self.topics = self.profileInfo[@"topics"];
        [self.tableView reloadData];
        [self loadProfilePhoto];
    }];

}

-(void)loadProfilePhoto{
    NSURL *url=[NSURL URLWithString:self.profileInfo[@"photo"][@"highres_link"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         UIImage *imagemain=[UIImage imageWithData:data];
        self.avatarImage.image=imagemain;
     }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
    NSDictionary *topic = [self.topics objectAtIndex:indexPath.row];
    cell.textLabel.text = topic[@"name"];
    return cell;
}


@end
