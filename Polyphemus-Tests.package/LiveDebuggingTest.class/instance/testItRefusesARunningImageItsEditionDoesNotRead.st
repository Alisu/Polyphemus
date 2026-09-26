tests
testItRefusesARunningImageItsEditionDoesNotRead

	"Held and asked its version, an image of a Pharo the edition does not read is let go again
	and refused by name, before anything reads it as if it were one."

	| pid other |
	pid := self launchSpinningTarget.
	other := PolyphemusEdition host: PolyphemusHost current targets: #( 99 ).
	[
	self
		should: [ PolyphemusEdition using: other during: [ Polyphemus holdProcess: pid watchedIn: self spikeDirectory ] ]
		raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'for-Pharo99') ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it was left held' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
