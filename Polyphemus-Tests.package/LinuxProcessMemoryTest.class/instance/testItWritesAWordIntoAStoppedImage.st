tests
testItWritesAWordIntoAStoppedImage

	"The half #24 needs beyond reading: a word set from outside is in the image when it is
	read again. A count of stack overflows is inert in an idle image, and is kept by VM 9 and
	VM 10 alike (the interrupt keycode was, until VM 10 dropped it)."

	| pid reader address was |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'statStackOverflow'.
	was := reader unsignedAt: address size: 8.

	reader whileStopped: [ reader storeWord: was + 1 at: address ].

	self assert: (reader unsignedAt: address size: 8) equals: was + 1 ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
