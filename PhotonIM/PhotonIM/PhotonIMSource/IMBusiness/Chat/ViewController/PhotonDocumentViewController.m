//
//  PhotonDocumentViewController.m
//  PhotonIM
//
//  Created by Bruce on 2020/2/17.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonDocumentViewController.h"

@interface PhotonDocumentViewController ()
@property(nonatomic,strong) NSArray *data;
@end

@implementation PhotonDocumentViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文件列表";
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_equalTo(0);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.data = nil;//[[PhotonIMClient sharedClient] getDocumentFiles];
    if (!self.data || self.data.count == 0) {
        NSArray *items = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:@"Files"];
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:items.count];
        for (NSString *filePath in items) {
            NSInteger fileSize = (NSInteger)[self fileSizeWithPath:filePath];
            NSString *displayName = filePath.lastPathComponent;
            PhotonIMFileBody *body = [PhotonIMFileBody fileBodyWithFilePath:filePath displayName:displayName];
            body.fileSize = fileSize;
            [datas addObject:body];
        }
        self.data = [datas copy];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotonIMFileBody *body = self.data[indexPath.row];
    
    if (self.completionBlock) {
        self.completionBlock(body,body.localFilePath.pathExtension);
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     PhotonIMFileBody *body = self.data[indexPath.row];
     cell.textLabel.text = body.fileDisplayName;
    return cell;
}


- (unsigned long long)fileSizeWithPath:(NSString *)filepath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    unsigned long long fileSize = 0;
    if ([filepath length]  && [fileManager fileExistsAtPath:filepath])
    {
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filepath
                                                          error:nil];
        id item = [attributes objectForKey:NSFileSize];
        fileSize = [item isKindOfClass:[NSNumber class]] ? [item unsignedLongLongValue] : 0;
    }
    return fileSize;
    
    
}
@end
