import os
import datetime
import time
import email.utils
from datagrok.misc import health

# todo: split foods up even more

# todo: don't send if weightfile has been updated between 24-36 hours ago.
# admonish if updated > 36 hours ago.

targetweight = 160.0
rhr = 67
weightfile = os.path.expanduser('~/etc/weight')
fdos = datetime.datetime(2011, 6, 21) # first day of summer

now = datetime.datetime.now()
daysleft = (fdos - now).days

weight = float(open(weightfile).read().strip())
weightfilemod = now - datetime.datetime.fromtimestamp(os.path.getmtime(weightfile))
cpp = health.calories_per_pound
ppk = health.pounds_per_kilogram
dpy = 365.2425 # days per year

lbleft = weight - targetweight
kgleft = lbleft * ppk

myage = (now - datetime.datetime(1980, 9, 17)).days / dpy
skinny_bmr = health.bmr(True, myage, targetweight, 6*12+1)
my_bmr = health.bmr(True, myage, weight, 6*12+1)

ppw = lbleft / daysleft * 7 # pounds per week to lose
cpd = lbleft / daysleft * cpp - my_bmr + skinny_bmr # calories per day to burn

walkmiles = cpd / 2 / (weight * health.ncbfactor_walking)
runmiles = cpd / 2 / (weight * health.ncbfactor_running)

message = '''From: "Fatass Reminder Robot" <mike+frr@datagrok.org>
To: mike@datagrok.org
Date: %(date)s
Subject: Mike needs to lose %(lbleft).0f lbs in %(daysleft)d days.

Today is %(today)s. The first day of summer is %(fdos)s. That's %(daysleft)d days away.

Mike still needs to lose %(lbleft)4.1f lbs (%(kgleft)4.1f kg). (Last update: %(hoursago)s ago).

This is %(ppw)4.2f pounds per week.

It takes %(my_bmr)d calories to maintain Mike's current weight. 
It takes %(skinny_bmr)d calories to maintain Mike's target weight.

The difference, %(cpd)d calories, is equivalent to:

- Mike walking %(walkmiles)4.1f miles (~%(walkmins)d minutes), or
- Mike running %(runmiles)4.1f miles (~%(runmins)d minutes).

And then

- Eating %(cheesburger).f less Mcdonald's double cheeseburgers, or
- Eating %(bread).f less slices of bread, or
- Drinking %(milk).f less cups of milk.

Mike's target heart rate: %(heartrate)s.

''' % {
    'date': email.utils.formatdate(),
    'lbleft': lbleft,
    'daysleft': daysleft,
    'today': now.strftime('%B %d'),
    'fdos': fdos.strftime('%B %d'),
    'kgleft': kgleft,
    'ppw': ppw,
    'my_bmr': my_bmr,
    'skinny_bmr': skinny_bmr,
    'cpd': cpd,
    'hoursago': '%dd %dh' % (weightfilemod.days, weightfilemod.seconds / 60 / 60),
    'walkmiles': walkmiles,
    'runmiles': runmiles,
    'walkmins': walkmiles / 3.5 * 60,
    'runmins': runmiles / 5.5 * 60,
    'cheesburger': cpd / 2 / 460.,
    'bread': cpd / 2 / 60.,
    'milk': cpd / 2 / 120.,
    'heartrate': 'Between %d and %d, do not go over %d' % (health.karvonen_heartrate(myage, rhr)[1:]),
}

print message
