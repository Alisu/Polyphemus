checking
check

	"Climb the ladder. A global rung failing stops it -- the rungs above cannot be tested,
	and guessing at them would be the dishonesty this exists to avoid. A local one is
	recorded and the climb goes on, because damage in one part of a heap says nothing about
	another: a walk that stopped halfway still leaves a class table that is perfectly
	readable."

	| found |
	found := Dictionary new.
	self levels do: [ :level |
		(self stopped: found) ifFalse: [
			| why |
			why := self whyCannotRead: level.
			why ifNotNil: [ found at: level put: why ] ] ].
	^ found
