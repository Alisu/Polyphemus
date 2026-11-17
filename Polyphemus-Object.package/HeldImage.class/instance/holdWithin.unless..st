holding
holdWithin: aDuration unless: aCondition

	"Hold it as holdWithin: does, unless aCondition, checked once the image is stopped, says it holds
	already (a trap that fired, #137); answers whether this did. A hold that fails while it is asked
	for, or is not taken in time, leaves nothing behind (giveUpTheHold, #181)."

	| hash held asked |
	(HoldLock on: directory) take.
	held := false.
	asked := false.
	[
	hash := self whileStoppedOnAProcessItCanHold: [
		        aCondition value ifFalse: [
			        held := true.
			        self forget: #( 'interrupted' 'released' ).
			        (directory / 'hold') ensureCreateFile.
			        self ringForAHold ] ].
	asked := true ] valueThenLetGo: [ asked ifFalse: [ self giveUpTheHold ] ].
	held ifFalse: [ ^ false ].
	(self waitFor: 'interrupted' within: aDuration) ifFalse: [
		| why |
		why := self whyTheInterruptWasNotTaken.
		self giveUpTheHold.
		^ HoldFailed signal: 'the image never took the interrupt: is it running the watcher on '
			  , directory fullName , '?' , why ].
	self serveAndHold: hash startingAt: nil.
	self checkItsVersion.
	^ true
