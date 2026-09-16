checking
check

	"Walk the ladder from the bottom. Once a rung fails, the ones above it are not tested:
	they cannot be, and guessing at them would be exactly the dishonesty this is for."

	| found |
	found := Dictionary new.
	self levels do: [ :level |
		found isEmpty ifTrue: [
			| why |
			why := self whyCannotRead: level.
			why ifNotNil: [ found at: level put: why ] ] ].
	^ found
