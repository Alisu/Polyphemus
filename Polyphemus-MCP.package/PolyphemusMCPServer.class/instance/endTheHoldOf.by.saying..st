tools
endTheHoldOf: someArguments by: aBlock saying: aString

	"aBlock given the session held as the handle, then the handle forgotten: once the hold has
	ended, not before, so that one that fails can be tried again (#180)."

	| handle |
	aBlock value: (self sessionAt: someArguments).
	handle := someArguments at: 'handle'.
	self images removeKey: handle.
	^ self text: aString structured: (Dictionary new at: 'handle' put: handle; yourself)
