# Cherry MX keyswitch footprint for use with gEDA/pcb
# 
# Lovingly and painstakingly created by Michael F. Lamb <mike@datagrok.org>
# 2011-12-28
#
# Which is not to say that it actually works or is error-free; this is my first
# ever footprint created for PCB and I have not (yet) tested the result of
# having it manufactured.

# Datasheet: http://www.cherrycorp.com/english/switches/pdf/mx_cat.pdf
# 10 mil silks, 10mil annelar rings.

# Pin (rX rY Thickness Clearance Mask Drill "Name" "Number" NFlags)

Element(0x00000000 "Cherry MX KeySwitch w/fixing pins, LED, diode" "" "" 10 10 0 0 0 100 0x00000000)
(
	# Holes for non-data plastic mounting hardware
	Pin(   0    0 157  0   157 157 "" ""  0x00000008) # Center hole
	Pin(-200    0  67  0    67  67 "" ""  0x00000008) # Left fixing pin
	Pin( 200    0  67  0    67  67 "" ""  0x00000008) # Right fixing pin

	# Data pins
	Pin(-150 -100  79  40  79  59 "" "1" 0x00000001) # Left signal pin
	Pin( 100 -200  79  40  79  59 "" "2" 0x00000001) # Right signal pin
	Pin( 150  200  59  40  59  39 "" "3" 0x00000001) # Left diode/bridge pin
	Pin(-150  200  59  40  59  39 "" "4" 0x00000001) # Right diode/bridge pin
	Pin(  50  200  59  40  59  39 "" "5" 0x00000001) # Left LED pin
	Pin( -50  200  59  40  59  39 "" "6" 0x00000001) # Right LED pin

	# Corner extent indicators
	ElementArc(-263 -263 12 12   0 -90 10)
	ElementArc(-263  263 12 12  90 -90 10)
	ElementArc( 263  263 12 12 180 -90 10)
	ElementArc( 263 -263 12 12 270 -90 10)

	# LED circular marks
	ElementArc(   0  200  60  60  45 90 10)
	ElementArc(   0  200  80  80  45 90 10)
	ElementArc(   0  200  60  60 225 90 10)
	ElementArc(   0  200  80  80 225 90 10)

	# Diode symbol
	ElementLine( -20 200 -10 200 10)
	ElementLine(  20 200  10 200 10)
	ElementLine( -10 180 -10 220 10)
	ElementLine(  10 180  10 220 10)
	ElementLine(  10 180 -10 200 10)
	ElementLine(  10 220 -10 200 10)

    # Keycap outline; 0.75" square
	# ElementLine( -375 -375 -375  375 10)
	# ElementLine( -375 -375  375 -375 10)
	# ElementLine(  375  375 -375  375 10)
	# ElementLine(  375  375  375 -375 10)
	)
