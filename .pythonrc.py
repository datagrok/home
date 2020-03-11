from sys import version
if version[:3] == '2.2':
	pass
elif getattr(__builtins__, '__IPYTHON__active', False):
	pass
else:
	import readline, rlcompleter
	readline.parse_and_bind("tab: complete")
