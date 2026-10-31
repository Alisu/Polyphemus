private
takeOutTheTrapRunningUntil: aMethodSource

	"Held after the deadline: the trap taken out answers false; fired, this hold is the trap's, true.
	Claimed and not through, its hold comes once this one ends: answers nil to wait for it (#137)."

	| removal |
	removal := process ask: (PolyphemusAgent trapRemovalSourceIn: directory).
	removal = #removed printString ifTrue: [ ^ false ].
	removal = #fired printString ifTrue: [
		process := HeldProcess
			           on: process channel
			           reader: reader
			           identityHash: self trapsProcessHash
			           startingAt: aMethodSource.
		^ true ].
	self forget: #( 'interrupted' 'released' 'hold' ).
	process letGo.
	(self waitFor: 'trap' within: 1 minute) ifFalse: [
		^ self error: 'a process claimed the trap and never said so' ].
	^ nil
