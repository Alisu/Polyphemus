locking
refuseAnothersLock

	"Refused while another observer that still runs has the lock."

	self owner ifNotNil: [ :owner |
		(owner ~= self hosts ownPid and: [ self hosts processExists: owner ]) ifTrue: [
			HoldFailed signal: 'observer ' , owner printString , ' holds the image watched in ' , directory fullName ] ]
