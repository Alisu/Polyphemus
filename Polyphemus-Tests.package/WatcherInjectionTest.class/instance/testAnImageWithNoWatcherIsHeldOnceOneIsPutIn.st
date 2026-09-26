tests
testAnImageWithNoWatcherIsHeldOnceOneIsPutIn

	"A stock image spinning in a loop: nothing waits on its interrupt semaphore, and signalling
	it does nothing. Once a watcher is put in, it is held on what it is busy with, and goes."

	| pid session |
	pid := self launchStockSpinningTarget.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self
		assert: (session heldProcess ask:
				 '((self at: #process) suspendedContext findContextSuchThat: [ :each | each selector == #timesRepeat: ]) notNil')
		equals: 'true'.
	session resume.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
