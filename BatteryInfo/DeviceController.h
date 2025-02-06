#import <Foundation/Foundation.h>

@interface DeviceController : NSObject

//- (BOOL) RebootDevice;
- (void) Respring;
- (NSString *) getBatteryHealthData;
- (void)copyBatteryHealthDataToDirectory:(NSString *)destDir;
@end
