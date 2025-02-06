#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/sysctl.h>
#import <Foundation/Foundation.h>

#define SOURCE_PATH "/var/MobileSoftwareUpdate/Hardware/Battery/Library/Preferences/com.apple.batteryhealthdata.plist"

void copy_file(const char *src, const char *dst) {
    int src_fd, dst_fd;
    char buffer[4096];
    ssize_t bytes_read, bytes_written;

    // 打开源文件
    src_fd = open(src, O_RDONLY);
    if (src_fd < 0) {
        perror("ERROR: Failed to open source file");
        exit(EXIT_FAILURE);
    }

    // 打开目标文件
    dst_fd = open(dst, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (dst_fd < 0) {
        perror("ERROR: Failed to open destination file");
        close(src_fd);
        exit(EXIT_FAILURE);
    }

    // 复制文件内容
    while ((bytes_read = read(src_fd, buffer, sizeof(buffer))) > 0) {
        bytes_written = write(dst_fd, buffer, bytes_read);
        if (bytes_written != bytes_read) {
            perror("ERROR: Failed to write to destination file");
            close(src_fd);
            close(dst_fd);
            exit(EXIT_FAILURE);
        }
    }

    // 关闭文件
    close(src_fd);
    close(dst_fd);

    printf("File copied successfully to %s\n", dst);
}

int main(int argc, char *argv[]) {
    
    @autoreleasepool {
        // 确保以 root 权限运行
        setuid(0);
        setgid(0);

        if (getuid() != 0) {
            printf("ERROR: BatteryHealthCopyHelper must be run as root.\n");
            return EXIT_FAILURE;
        }

        // 检查参数
        if (argc != 2) {
            printf("Usage: BatteryHealthCopyHelper <destination_directory>\n");
            return EXIT_FAILURE;
        }

        // 获取目标目录路径
        const char *dest_dir = argv[1];

        // 构建目标文件路径
        char dest_path[1024];
        snprintf(dest_path, sizeof(dest_path), "%s/com.apple.batteryhealthdata.plist", dest_dir);

        // 复制文件
        copy_file(SOURCE_PATH, dest_path);

        // 返回成功信息
        printf("{\"status\": \"success\", \"message\": \"File copied to %s\"}\n", dest_path);

        return EXIT_SUCCESS;
    }
    
}
