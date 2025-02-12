#import <Foundation/Foundation.h>

@interface DeviceController : NSObject

//- (BOOL) RebootDevice;
- (void) Respring;

@end

int spawnRoot(NSString *path, NSArray *args, NSString **stdOut, NSString **stdErr);
