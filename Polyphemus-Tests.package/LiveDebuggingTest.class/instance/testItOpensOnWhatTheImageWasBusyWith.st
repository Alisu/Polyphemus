tests
testItOpensOnWhatTheImageWasBusyWith

	"The process running when the image was stopped to be interrupted, asked of the image
	itself: the runaway, whose stack holds its Interval>>do: loop -- not the UI process waiting
	ahead of it in the same queue."

	| pid session |
	pid := self launchSpinningTarget.
	[
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self
		assert: (session heldProcess ask:
				 '((self at: #process) suspendedContext findContextSuchThat: [ :each | each selector == #do: ]) notNil')
		equals: 'true'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
