//
//  main.m
//  Screenshot

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

extern void xpc_connection_set_legacy(xpc_connection_t connection);

void handleConnectionSetupError(xpc_object_t _Nonnull object);
void handleMessageReplyAndExit(xpc_object_t _Nonnull object);

int main(int argc, const char * argv[]) {
    xpc_connection_t connection = xpc_connection_create("com.apple.systemuiserver.screencapture", dispatch_get_main_queue());
    xpc_connection_set_legacy(connection);
    xpc_connection_set_event_handler(connection, ^(xpc_object_t  _Nonnull object) {
        handleConnectionSetupError(object);
    });
    xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
    xpc_dictionary_set_uint64(message, "message", 1);
    xpc_object_t args = xpc_array_create(NULL, 0);
    xpc_object_t arg = xpc_string_create("-uUpi");
    xpc_array_append_value(args, arg);
    xpc_dictionary_set_value(message, "args", args);
    xpc_object_t nowait = xpc_bool_create(true);
    xpc_dictionary_set_value(message, "nowait", nowait);
    xpc_connection_send_message_with_reply(connection, message, dispatch_get_main_queue(), ^(xpc_object_t  _Nonnull object) {
        handleMessageReplyAndExit(object);
    });
    xpc_connection_resume(connection);
    dispatch_main();
}

void handleConnectionSetupError(xpc_object_t _Nonnull object) {
    xpc_type_t type = xpc_get_type(object);
    if (type == XPC_TYPE_ERROR) {
        const char *error = xpc_dictionary_get_string(object, XPC_ERROR_KEY_DESCRIPTION);
        NSLog(@"screencapture XPC message error during setup: %s\n", error);
    } else {
        char *description = xpc_copy_description(object);
        if (description != NULL) {
            NSLog(@"screencapture XPC message error during setup - unknown XPC message type %p for connection handler: %s\n", type, description);
            free(description);
        }
    }
}

void handleMessageReplyAndExit(xpc_object_t _Nonnull object) {
    xpc_type_t type = xpc_get_type(object);
    if (type == XPC_TYPE_ERROR) {
        const char *error = xpc_dictionary_get_string(object, XPC_ERROR_KEY_DESCRIPTION);
        NSLog(@"screencapture XPC message returned error: %s\n", error);
    } else if (type != XPC_TYPE_DICTIONARY) {
        char *description = xpc_copy_description(object);
        if (description != NULL) {
            NSLog(@"screencapture XPC message returned error - unknown XPC message type %p for reply: %s\n", type, description);
            free(description);
        }
    }
    exit(0);
}
