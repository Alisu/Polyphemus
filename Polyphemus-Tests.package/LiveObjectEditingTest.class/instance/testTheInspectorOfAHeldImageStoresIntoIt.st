tests
testTheInspectorOfAHeldImageStoresIntoIt

	"Typed in the Oop tab of an object a held image shows, a value lands in the image: each
	reading of it has the held process as its editor (#20)."

	| pid session |
	pid := self launchFlagTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	(self flagIn: session) store: '2' inItemKeyed: 'slot 1'.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'stopped') exists ])
		description: 'the image never saw the slot set' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
