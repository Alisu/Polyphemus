tests
testTheImageGoesOnWithASlotSetInTheDebugger

	"A slot of an object the debugger shows, set while the image is held (#20): let go, the
	image goes on with it -- here out of the loop that kept it running away."

	| pid session flag |
	pid := self launchFlagTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	flag := self flagIn: session.
	self assert: (flag reifiedSlotAt: 1) asInteger equals: 1.
	session store: 2 inSlot: 1 ofObjectShown: flag.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'stopped') exists ])
		description: 'the image never saw the slot set' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
