//
//  ViewController.m
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import "ViewController.h"
#import "ESPictureModel.h"
#import "ESCellNode.h"
#import <AsyncDisplayKit.h>
#import <PINCache/PINCache.h>
#import <YYWebImage/YYWebImage.h>

@interface ViewController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) ASTableView *tableView;
    
@end

@implementation ViewController
    
- (NSArray *)datas {
    if (_datas == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"list.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray *result = [NSMutableArray array];
        for (NSArray *value in array) {
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                ESPictureModel *model = [ESPictureModel new];
                [model setValuesForKeysWithDictionary:dict];
                [arrayM addObject:model];
            }
            [result addObject:arrayM];
        }
        _datas = [result copy];
    }
    return _datas;
}

- (void)loadView {
    ASTableView *tableView = [ASTableView new];
    tableView.asyncDelegate = self;
    tableView.asyncDataSource = self;
    self.view = tableView;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearCache)];
}

- (void)clearCache {
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}
    
- (void)dealloc {
    NSLog(@"销毁");
}

#pragma mark - "代理数据源方法"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ESCellNode *node = [ESCellNode new];
    NSArray *pictureModels = self.datas[indexPath.row];
    [node setPictureModels:pictureModels];
    return node;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end

