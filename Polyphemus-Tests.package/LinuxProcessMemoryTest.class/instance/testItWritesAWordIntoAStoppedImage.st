tests
testItWritesAWordIntoAStoppedImage

	"The half #24 needs beyond reading: a word set from outside is in the image when it is
	read again. The keycode the VM watches for an interrupt is inert in a headless image,
	which has no keyboard to press it."

	| pid reader address was |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'interruptKeycode'.
	was := reader unsignedAt: address size: 8.

	reader whileStopped: [ reader storeWord: was + 1 at: address ].

	self assert: (reader unsignedAt: address size: 8) equals: was + 1 ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
