//
//  AAPLImage.h
//  MetalDemo
//
//  Created by keyl on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAPLImage : NSObject

- (instancetype)initWithTGAFileAtLocation:(NSURL *)location;

@property (nonatomic, readonly, assign) NSUInteger width;

@property (nonatomic, readonly, assign) NSUInteger height;

@property (nonatomic, readonly, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
