//
//  DataSource.h
//  DictObjc
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

@import UIKit;

@class QueryRecord;

typedef UITableViewCell* (^ CellConfigure)(UITableViewCell *cell, QueryRecord *record);

@interface DataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithCellConfigure:(CellConfigure)configure
                      reuseIdentifier:(NSString *)reuseIdentifier;

- (NSIndexPath *)addTerm:(NSString *)term isNewTerm:(out BOOL *)newTerm;
- (void)moveTermAtIndexPath:(NSIndexPath *)from toIndexPath:(NSIndexPath *)to;
- (NSString *)termAtIndexPath:(NSIndexPath *)indexPath;

@end
