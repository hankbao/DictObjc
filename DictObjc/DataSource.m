//
//  DataSource.m
//  DictObjc
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

#import "DataSource.h"
#import "QueryRecord.h"


@interface DataSource ()

@property (nonatomic, copy) NSMutableArray<QueryRecord *> *queryRecords;
@property (nonatomic, copy) CellConfigure configure;
@property (nonatomic, copy) NSString *reuseIdentifier;

@end

@implementation DataSource

- (instancetype)initWithCellConfigure:(CellConfigure)configure
                      reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super init]) {
        _queryRecords = [NSMutableArray array];
        _configure = [configure copy];
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

- (NSIndexPath *)addTerm:(NSString *)term isNewTerm:(out BOOL *)newTerm {
    __block NSInteger row = NSNotFound;
    [self.queryRecords enumerateObjectsUsingBlock:
        ^ (QueryRecord * _Nonnull record, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([record.term isEqualToString:term]) {
                row = idx;
                *stop = YES;
            }
    }];

    if (NSNotFound == row) {
        [self.queryRecords addObject:[[QueryRecord alloc] initWithTerm:term]];
        *newTerm = YES;
        return [NSIndexPath indexPathForRow:self.queryRecords.count - 1 inSection:0];
    } else {
        *newTerm = NO;
        self.queryRecords[row].queryCount += 1;
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
}

- (void)moveTermAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to {
    QueryRecord *record = self.queryRecords[from.row];
    [self.queryRecords removeObjectAtIndex:from.row];
    [self.queryRecords insertObject:record atIndex:to.row];
}

- (NSString *)termAtIndexPath:(NSIndexPath *)indexPath {
    return self.queryRecords[indexPath.row].term;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.queryRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QueryRecord *record = self.queryRecords[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier
                                                            forIndexPath:indexPath];
    return self.configure(cell, record);
}

@end
