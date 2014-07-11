//
//  TKMacro.h
//  TapKit
//
//  Created by Kevin on 5/21/14.
//  Copyright (c) 2014 Tapmob. All rights reserved.
//

#ifdef __cplusplus
extern "C" {
#endif

///-------------------------------
/// Debug
///-------------------------------

#ifdef DEBUG
#define TKPRINT(_fmt_, ...) NSLog(@"%s: "_fmt_, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define TKPRINT(_fmt_, ...) ((void)0)
#endif

#ifdef DEBUG
#define TKPRINTMETHOD() NSLog(@"%s", __PRETTY_FUNCTION__)
#else
#define TKPRINTMETHOD() ((void)0)
#endif


///-------------------------------
/// Time interval
///-------------------------------

#define TKTimeIntervalMinute()  (60.0)
#define TKTimeIntervalHour()    (60.0*60)
#define TKTimeIntervalDay()     (60.0*60*24)
#define TKTimeIntervalWeek()    (60.0*60*24*7)


///-------------------------------
/// Color shortcut
///-------------------------------

#define TKRGBA(_r_, _g_, _b_, _a_)  ([UIColor colorWithRed:(_r_)/255.0 green:(_g_)/255.0 blue:(_b_)/255.0 alpha:(_a_)/255.0])
#define TKRGB(_r_, _g_, _b_)        ([UIColor colorWithRed:(_r_)/255.0 green:(_g_)/255.0 blue:(_b_)/255.0 alpha:1.0])

#ifdef __cplusplus
}
#endif
