//
//  QueryRecord.m
//  DictObjc
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

#import "QueryRecord.h"

@implementation QueryRecord {
    NSString* _term;
}

- (NSString *)term {
    return self->_term;
}

- (instancetype)initWithTerm:(NSString *)term {
    if (self = [super init]) {
        self->_term = term;
        _date = [NSDate date];
        _queryCount = 1;
    }

    return self;
}

@end
