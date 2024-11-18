//
//  main.m
//  Mission Control

#import <CoreFoundation/CoreFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

extern void CoreDockSendNotification(CFStringRef, void *);

int main(int argc, const char *argv[]) __attribute__((used)) __asm__("EntryPoint");

int main(int argc, const char * argv[]) {
    CFStringRef notification = NULL;
    if (argc >= 2) {
        int value = atoi(argv[1]);
        switch (value) {
            case 0:
                notification = CFSTR("com.apple.expose.awake");
                break;
            case 1:
                notification = CFSTR("com.apple.showdesktop.awake");
                break;
            case 2:
                notification = CFSTR("com.apple.expose.front.awake");
                break;
            default:
                break;
        }
    }
    notification = notification ?: CFSTR("com.apple.expose.awake");
    CoreDockSendNotification(notification, NULL);
    return 0;
}
