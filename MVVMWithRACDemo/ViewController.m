//
//  ViewController.m
//  MVVMWithRACDemo
//
//  Created by Liusui on 16/6/28.
//  Copyright © 2016年 Shanghai Elephant Financial Services Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AddressBookCell.h"
#import "AddressBookViewModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddressBookViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
}

- (void)loadData{
    self.viewModel = [[AddressBookViewModel alloc]init];
    @weakify(self);
    [[self.viewModel getAddressBookInformation] subscribeNext:^(id x) {
        @strongify(self);
        self.dataArray = [NSMutableArray arrayWithArray:(NSArray *)x];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressBookCell" forIndexPath:indexPath];
    cell.callBtn.rac_command = [self.viewModel callButtonCommandWithModel:_dataArray[indexPath.row]];
    [cell bindWithViewModel:_dataArray[indexPath.row]];
    return cell;
}

@end
