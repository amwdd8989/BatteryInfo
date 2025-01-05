#import "BatteryHelper.h"
#import <IOKit/IOKitLib.h>

NSDictionary *getBatteryInfo() {
    mach_port_t masterPort;
    CFMutableDictionaryRef matchingDict;
    io_service_t service;
    CFMutableDictionaryRef properties = NULL;

    // 获取主端口
    IOMasterPort(MACH_PORT_NULL, &masterPort);

    // 匹配电池服务
    matchingDict = IOServiceMatching("AppleSmartBattery");
    service = IOServiceGetMatchingService(masterPort, matchingDict);

    if (service) {
        // 获取电池属性
        IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0);
        IOObjectRelease(service);
    }

    if (properties) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)properties];
        CFRelease(properties); // 手动释放
        return result;
    }

    return nil;
}
