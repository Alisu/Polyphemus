instance creation
on: aChannel reader: aProcessMemory identityHash: anInteger startingAt: aMethodSourceOrNil

	"The process with that identity hash, its debugger there at its top context -- or at the
	context of that method, below whatever was called from it."

	^ self new
		  setChannel: aChannel
		  reader: aProcessMemory
		  identityHash: anInteger
		  startingAt: aMethodSourceOrNil
