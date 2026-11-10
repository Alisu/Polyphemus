locking
take

	"Ours for the whole hold, or refused while another observer that still runs has it; one whose
	observer died, or that names none, is taken over."

	| mine fresh |
	mine := self hosts ownPid.
	self owner
		ifNil: [ self lockDirectory ensureDeleteAll ]
		ifNotNil: [ :owner |
			owner = mine ifTrue: [ ^ self ].
			(self hosts processExists: owner) ifTrue: [
				^ HoldFailed signal: 'observer ' , owner printString , ' holds the image watched in ' , directory fullName ].
			self lockDirectory ensureDeleteAll ].
	fresh := directory / ('hold.lock-' , UUID new asString).
	fresh ensureCreateDirectory.
	(fresh / 'owner') writeStreamDo: [ :stream | stream print: mine ].
	[ fresh renameTo: self lockDirectory basename ] on: Error do: [ :error |
		fresh ensureDeleteAll.
		self owner ifNil: [ ^ HoldFailed signal: 'cannot lock ' , directory fullName , ': ' , error messageText asString ].
		^ self take ]
