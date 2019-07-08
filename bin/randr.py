#!/bin/python3
"""
The xrandr names (DP-1, DP-2) for my monitors tends to flip around depending on
which one happens to become active first. This script figures out which is which
by the EDID, and runs xrandr to apply the layout correctly.

"""

import re
import subprocess

# map from arbitrary descriptions of my monitors to their serial numbers, as
# reported by the last 16 hexadecimal characters in the first line of their
# EDID. (Run xrandr --verbose)
names_serials = {
    'l': '0469a12894840200',
    'r': '0469f627f0960100',
}

edid_re = re.compile(r'([\w\d-]+)\sconnected.*?00ffffffffffff00([\d\w]{16})',
                     re.S)

if __name__ == '__main__':
    serials_rnames = {
        hexstr: name
        for name, hexstr in edid_re.findall(
            subprocess.check_output(['xrandr', '--verbose']).decode('utf-8'))
    }

    def monitor(s):
        return serials_rnames[names_serials[s]]

    xrandrcmd = '''
        xrandr
        --output HDMI-2 --off
        --output HDMI-1 --off
        '''
    try:
        xrandrcmd += f'''
            --output eDP-1 --primary --mode 1920x1080 --pos 1080x1080 --rotate normal
            --output {monitor('r')} --mode 1920x1080 --pos 1080x0 --rotate normal
            --output {monitor('l')} --mode 1920x1080 --pos 0x0 --rotate right
            '''
    except KeyError:
        xrandrcmd += '''
            --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
            --output DP-2 --off
            --output DP-1 --off
            '''
    print(xrandrcmd)
    subprocess.check_call(xrandrcmd.split())
