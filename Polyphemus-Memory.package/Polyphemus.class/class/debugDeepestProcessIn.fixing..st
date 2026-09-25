tools
debugDeepestProcessIn: aReifiedMemory fixing: aMethodFix

	"The real Pharo debugger on the deepest stack in the memory, with its code pane able to
	write back: accepting there compiles here and installs in the image being read."

	^ StDebugger
		  openOn: ((self sessionOnDeepestProcessIn: aReifiedMemory)
				   fix: aMethodFix;
				   yourself)
		  withFullView: true
