#import "BatteryHelper.h"
#import <dlfcn.h>
#import <IOKit/IOKitLib.h>

NSDictionary *getBatteryInfo() {
    CFMutableDictionaryRef matchingDict;
    io_service_t service;
    CFMutableDictionaryRef properties = NULL;

    // 动态加载 IOKit 符号
    void *handle = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (!handle) {
        NSLog(@"Failed to load IOKit framework");
        return nil;
    }

    CFMutableDictionaryRef (*IOServiceMatchingPtr)(const char *) = dlsym(handle, "IOServiceMatching");
    io_service_t (*IOServiceGetMatchingServicePtr)(mach_port_t, CFDictionaryRef) = dlsym(handle, "IOServiceGetMatchingService");
    kern_return_t (*IORegistryEntryCreateCFPropertiesPtr)(io_service_t, CFMutableDictionaryRef *, CFAllocatorRef, IOOptionBits) = dlsym(handle, "IORegistryEntryCreateCFProperties");
    kern_return_t (*IOObjectReleasePtr)(io_object_t) = dlsym(handle, "IOObjectRelease");

    if (!IOServiceMatchingPtr || !IOServiceGetMatchingServicePtr || !IORegistryEntryCreateCFPropertiesPtr || !IOObjectReleasePtr) {
        NSLog(@"Failed to locate IOKit symbols");
        dlclose(handle);
        return nil;
    }

    // 匹配电池服务
    matchingDict = IOServiceMatchingPtr("AppleSmartBattery");
    service = IOServiceGetMatchingServicePtr(kIOMainPortDefault, matchingDict);

    if (service) {
        // 获取电池属性
        IORegistryEntryCreateCFPropertiesPtr(service, &properties, kCFAllocatorDefault, 0);
        IOObjectReleasePtr(service);
    }

    if (properties) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)properties];
        CFRelease(properties); // 手动释放
        dlclose(handle);
        return result;
    }

    dlclose(handle);
    return nil;
}
