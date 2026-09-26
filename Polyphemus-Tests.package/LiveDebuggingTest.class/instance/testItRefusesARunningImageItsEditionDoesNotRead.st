tests
testItRefusesARunningImageItsEditionDoesNotRead

	"Held and asked its version, an image of a Pharo the edition does not read is let go again
	and refused by name, before anything reads it as if it were one. The directory is taken
	before the edition changes: each edition has its own (#50)."

	| pid other directory |
	pid := self launchSpinningTarget.
	directory := self spikeDirectory.
	other := PolyphemusEdition host: PolyphemusHost current targets: #( 99 ).
	[
	self
		should: [ PolyphemusEdition using: other during: [ Polyphemus holdProcess: pid watchedIn: directory ] ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'does not read Pharo') ].
	self
		assert: (self waitFor: [ (directory / 'released') exists ])
		description: 'it was left held' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
