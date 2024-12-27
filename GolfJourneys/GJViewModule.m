#import "GJViewModule.h"

@implementation GJViewModule

+ (NSBundle *)moduleBundle {
    return [NSBundle mainBundle];
}

+ (Class)viewClassForIdentifier:(NSString *)identifier {
    NSString *className = [NSString stringWithFormat:@"GolfJourneys.%@", identifier];
    return NSClassFromString(className);
}

@end 