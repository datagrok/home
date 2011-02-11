#!/bin/python

'''Utility to watch and record active X11 window titles, so I can get some
statistics about where exactly my time goes.

'''

import Xlib.display
import time
import signal
import pprint
import ctypes
import os

stats = {}

class XScreenSaverInfo( ctypes.Structure):
    """ typedef struct { ... } XScreenSaverInfo; """
    _fields_ = [('window',      ctypes.c_ulong), # screen saver window
                ('state',       ctypes.c_int),   # off,on,disabled
                ('kind',        ctypes.c_int),   # blanked,internal,external
                ('since',       ctypes.c_ulong), # milliseconds
                ('idle',        ctypes.c_ulong), # milliseconds
                ('event_mask',  ctypes.c_ulong)] # events

def showstats(signum, stackframe):
    print '-' * 60
    table = [(time, label) for (label, time) in stats.items()]
    table.sort()
    for time, label in table:
        label = list(label)
        if label is None:
            label = "idle"

        if label[0] is None:
            label[0] = "None"
        else:
            label[0] = '/'.join(label[0])

        if not hasattr(label, 'upper'):
            label = ': '.join([str(x) for x in label])

        print "%2d:%02d:%02d %s" % (
            time / 60 / 60,
            time / 60 % 60,
            time % 60,
            label
        )


if __name__ == '__main__':
    signal.signal(signal.SIGUSR1, showstats)

    display = Xlib.display.Display()
    root = display.screen().root

    xlib = ctypes.cdll.LoadLibrary('libX11.so')
    xss = ctypes.cdll.LoadLibrary('libXss.so.1')
    dpy = xlib.XOpenDisplay(os.environ['DISPLAY'])
    root2 = xlib.XDefaultRootWindow(dpy)
    xss.XScreenSaverAllocInfo.restype = ctypes.POINTER(XScreenSaverInfo)
    xss_info = xss.XScreenSaverAllocInfo()

    while True:
        xss.XScreenSaverQueryInfo(dpy, root2, xss_info)
        idle = xss_info.contents.idle / 1000

        if idle < 30:
            window = display.get_input_focus().focus
            class_ = window.get_wm_class()
            name = window.get_wm_name()
            stats[(class_,name)] = stats.setdefault((class_, name), 0) + 1
        elif idle == 30:
            window = display.get_input_focus().focus
            class_ = window.get_wm_class()
            name = window.get_wm_name()
            stats[(class_,name)] = stats.setdefault((class_, name), 0) - 30
            stats['idle'] = stats.setdefault('idle', 0) + 30
        else:
            stats['idle'] = stats.setdefault('idle', 0) + 1

        time.sleep(1)
