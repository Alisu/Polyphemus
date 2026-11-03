instance creation
takeOver: aDebugger

	"Makes a debugger just built on a reading one of ours in place: same shape, its title kept."

	aDebugger class == StDebugger ifTrue: [ self adoptInstance: aDebugger ]
