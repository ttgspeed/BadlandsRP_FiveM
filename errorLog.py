import re
pattern = re.compile('(.*)\|ERROR\|(\w*)')
with open('server.log') as f:
	for line in f:
		match = pattern.match(line)
		if match is not None:
			time = match.group(1)
			message = match.group(2)
			print("ERROR: " + message + " : " + time)
