#!/bin/python3
"""
The xrandr names (DP-1, DP-2) for my monitors tends to flip around depending on
which one happens to become active first. This script figures out which is which
by the EDID, and runs xrandr to apply the layout correctly.

"""

import re
import subprocess

monitor_positions = {
    'l': '0469a12894840200',
    'r': '0469f627f0960100',
}

edid_re = re.compile(r'([\w\d-]+)\sconnected.*?00ffffffffffff00([\d\w]{16})',
                     re.S)

if __name__ == '__main__':
    monitor_names = {
        hexstr: name
        for name, hexstr in edid_re.findall(
            subprocess.check_output(['xrandr', '--verbose']).decode('utf-8'))
    }

    subprocess.check_call('''
        xrandr
        --output HDMI-2 --off
        --output HDMI-1 --off
        --output eDP-1 --primary --mode 1920x1080 --pos 3000x840 --rotate normal
        --output {} --mode 1920x1080 --pos 1920x0 --rotate right
        --output {} --mode 1920x1080 --pos 0x0 --rotate normal
        '''.format(
            monitor_names[monitor_positions['r']],
            monitor_names[monitor_positions['l']],
        ).split())
