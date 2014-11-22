//
//  PPCLog.h
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//


//
//  Lumberjack (third party)
//
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

// We want to use the following log levels:
//
// Error
// Warn
// Success
// Info
// Notice
// Trace
// Verbose
//
// All we have to do is undefine the default values,
// and then simply define our own however we want.

// First undefine the default stuff we don't want to use.

#undef LOG_FLAG_ERROR
#undef LOG_FLAG_WARN
#undef LOG_FLAG_INFO
#undef LOG_FLAG_VERBOSE

#undef LOG_LEVEL_ERROR
#undef LOG_LEVEL_WARN
#undef LOG_LEVEL_INFO
#undef LOG_LEVEL_VERBOSE

#undef LOG_ERROR
#undef LOG_WARN
#undef LOG_INFO
#undef LOG_VERBOSE

/*
 #undef DDLogError //(frmt, ...)
 #undef DDLogWarn //(frmt, ...)
 #undef DDLogInfo //(frmt, ...)
 #undef DDLogVerbose //(frmt, ...)
 
 #undef DDLogCError //(frmt, ...)
 #undef DDLogCWarn //(frmt, ...)
 #undef DDLogCInfo //(frmt, ...)
 #undef DDLogCVerbose //(frmt, ...)
 */

// Now define everything how we want it

#define LOG_FLAG_ERROR      (1 << 0)    //0...0000001
#define LOG_FLAG_WARN       (1 << 1)    //0...0000010
#define LOG_FLAG_SUCCESS    (1 << 2)    //0...0000100
#define LOG_FLAG_INFO       (1 << 3)    //0...0001000
#define LOG_FLAG_NOTICE     (1 << 4)    //0...0010000
#define LOG_FLAG_TRACE      (1 << 5)    //0...0100000
#define LOG_FLAG_VERBOSE    (1 << 6)    //0...1000000

#define LOG_LEVEL_OFF       0
#define LOG_LEVEL_ERROR     (LOG_FLAG_ERROR                                             )   //0...0000001
#define LOG_LEVEL_WARN      (LOG_FLAG_WARN      | LOG_LEVEL_ERROR                       )   //0...0000011
#define LOG_LEVEL_SUCCESS   (LOG_FLAG_SUCCESS   | LOG_LEVEL_WARN                        )   //0...0000111
#define LOG_LEVEL_INFO      (LOG_FLAG_INFO      | LOG_FLAG_NOTICE   | LOG_LEVEL_SUCCESS )   //0...0011111
#define LOG_LEVEL_TRACE     (LOG_FLAG_TRACE     | LOG_LEVEL_INFO                        )   //0...0111111
#define LOG_LEVEL_VERBOSE   (LOG_FLAG_VERBOSE   | LOG_LEVEL_TRACE                       )   //0...1111111

#define LOG_ERROR   (logLevel & LOG_FLAG_ERROR      )
#define LOG_WARN    (logLevel & LOG_FLAG_WARN       )
#define LOG_SUCCESS (logLevel & LOG_FLAG_SUCCESS    )
#define LOG_INFO    (logLevel & LOG_FLAG_INFO       )
#define LOG_NOTICE  (logLevel & LOG_FLAG_NOTICE     )
#define LOG_TRACE   (logLevel & LOG_FLAG_TRACE      )
#define LOG_VERBOSE (logLevel & LOG_FLAG_VERBOSE    )

//Asynchronous Logging
#define LogAsync   NO

//
//  Additional logs
//
#ifdef DEBUG    //Logging Enabled

static const int logLevel = LOG_LEVEL_VERBOSE;

#define LogError(frmt, ...)     LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_ERROR,      0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogWarn(frmt, ...)      LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_WARN,       0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogSuccess(frmt, ...)   LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_SUCCESS,    0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogInfo(frmt, ...)      LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_INFO,       0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogNotice(frmt, ...)    LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_NOTICE,     0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogVerbose(frmt, ...)   LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_VERBOSE,    0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogTrace()              LOG_OBJC_MAYBE(LogAsync, logLevel, LOG_FLAG_TRACE,      0, @"%@: %@", THIS_FILE, THIS_METHOD)

#define LogCError(frmt, ...)    LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_ERROR,         0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCWarn(frmt, ...)     LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_WARN,          0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCSuccess(frmt, ...)  LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_SUCCESS,       0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCInfo(frmt, ...)     LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_INFO,          0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCNotice(frmt, ...)   LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_NOTICE,        0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCVerbose(frmt, ...)  LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_VERBOSE,       0, (@"%@: " frmt), THIS_FILE, ##__VA_ARGS__)
#define LogCTrace()             LOG_C_MAYBE(LogAsync, logLevel, LOG_FLAG_TRACE,         0, @"%@: %s", THIS_FILE, __FUNCTION__)

#else   //Logging Disabled

static const int logLevel = LOG_LEVEL_OFF;

#define LogError(frmt, ...)     {}
#define LogWarn(frmt, ...)      {}
#define LogSuccess(frmt, ...)   {}
#define LogInfo(frmt, ...)      {}
#define LogNotice(frmt, ...)    {}
#define LogVerbose(frmt, ...)   {}
#define LogTrace()              {}

#define LogCError(frmt, ...)    {}
#define LogCWarn(frmt, ...)     {}
#define LogCSuccess(frmt, ...)  {}
#define LogCInfo(frmt, ...)     {}
#define LogCNotice(frmt, ...)   {}
#define LogCVerbose(frmt, ...)  {}
#define LogCTrace(frmt, ...)    {}

#endif