//
//  main.m
//  Launchpad

#import <CoreFoundation/CoreFoundation.h>
#import <ApplicationServices/ApplicationServices.h>

extern void CoreDockSendNotification(CFStringRef, void *);

int main(int argc, const char *argv[]) __attribute__((used)) __asm__("EntryPoint");

int main(int argc, const char * argv[]) {
    CoreDockSendNotification(CFSTR("com.apple.launchpad.toggle"), NULL);
    return 0;
}
