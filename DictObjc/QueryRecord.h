//
//  QueryRecord.h
//  DictObjc
//
//  Created by Hank Bao on 16/4/17.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

@import Foundation;

@interface QueryRecord : NSObject

@property (nonatomic, copy, readonly) NSString *term;
@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, assign) NSUInteger queryCount;

- (instancetype)initWithTerm:(NSString *)term;

@end
