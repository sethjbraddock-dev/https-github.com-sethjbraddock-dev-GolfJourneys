#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GJViewModule : NSObject

+ (NSBundle *)moduleBundle;
+ (Class)viewClassForIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END 