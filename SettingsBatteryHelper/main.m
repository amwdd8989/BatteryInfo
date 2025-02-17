#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string.h>
#include <CoreFoundation/CoreFoundation.h>

#define BATTERY_HEALTH_PATH "/var/MobileSoftwareUpdate/Hardware/Battery/Library/Preferences/com.apple.batteryhealthdata.plist"

void print_battery_health() {
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR(BATTERY_HEALTH_PATH), kCFURLPOSIXPathStyle, false);
    CFReadStreamRef stream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL);

    if (!stream || !CFReadStreamOpen(stream)) {
        printf("ERROR: Cannot open battery health file\n");
        return;
    }

    CFPropertyListRef plist = CFPropertyListCreateWithStream(kCFAllocatorDefault, stream, 0, kCFPropertyListImmutable, NULL, NULL);
    CFReadStreamClose(stream);
    CFRelease(stream);
    CFRelease(fileURL);

    if (!plist || CFGetTypeID(plist) != CFDictionaryGetTypeID()) {
        printf("ERROR: Invalid battery health data\n");
        return;
    }

    CFDictionaryRef dict = (CFDictionaryRef)plist;
    
    CFNumberRef cycleCountNum = CFDictionaryGetValue(dict, CFSTR("CycleCount"));
    CFNumberRef maxCapacityNum = CFDictionaryGetValue(dict, CFSTR("Maximum Capacity Percent"));

    int cycleCount = -1;
    int maxCapacity = -1;
    
    if (cycleCountNum) {
        CFNumberGetValue(cycleCountNum, kCFNumberIntType, &cycleCount);
    }

    if (maxCapacityNum) {
        CFNumberGetValue(maxCapacityNum, kCFNumberIntType, &maxCapacity);
    }

    printf("{\"CycleCount\": %d, \"Maximum Capacity Percent\": %d}\n", cycleCount, maxCapacity);
    CFRelease(plist);
}

int main(int argc, char *argv[]) {
    // 确保进程运行在 root 权限
    setuid(0);
    setgid(0);

    if (getuid() != 0) {
        printf("ERROR: BatteryHealthHelper must be run as root.\n");
        return -1;
    }
    
    print_battery_health();
    
    // 确保缓冲区刷新
    fflush(stdout);
    fflush(stderr);
    
    return 0;
}
