naming
addressOfFunction: aName

	"Where aName is in this process (dlsym, RTLD_DEFAULT); 0 when it is nowhere."

	^ MacProcessMemory dlsym: -2 named: aName
