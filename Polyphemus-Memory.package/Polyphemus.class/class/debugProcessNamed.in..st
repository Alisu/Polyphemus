tools
debugProcessNamed: aName in: aReifiedMemory

	"The real Pharo debugger, post mortem, on the process of that name (#92)."

	^ self debugProcess: (self processNamed: aName in: aReifiedMemory) in: aReifiedMemory
