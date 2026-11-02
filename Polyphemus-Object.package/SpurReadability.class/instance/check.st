checking
check

	"Climb the ladder. A global rung failing stops the climb; a local one is recorded and the
	climb goes on, since damage in one part of a heap says nothing about another."

	| found |
	found := Dictionary new.
	self levels do: [ :level |
		(self stopped: found) ifFalse: [
			(self reasonFor: level) ifNotNil: [ :why | found at: level put: why ] ] ].
	^ found
