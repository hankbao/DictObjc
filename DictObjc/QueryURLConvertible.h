//
//  QueryURLConvertible.h
//  DictObjc
//
//  Created by Hank Bao on 16/4/22.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

@import Foundation;

@protocol QueryURLConvertible <NSObject>

@property (nonatomic, strong, readonly) NSURL* zt_queryURL;

@end
