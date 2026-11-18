locking
take

	"Ours for the whole hold, or refused while another observer that still runs has it; one whose
	observer died, or that names none, is taken over. Read again and replaced under a guard, one
	observer at a time: a lock taken since it was read is another's (#181)."

	| mine |
	mine := self hosts ownPid.
	self owner = mine ifTrue: [ ^ self ].
	self refuseAnothersLock.
	self underTheGuardDo: [
		self owner = mine ifFalse: [
			self refuseAnothersLock.
			self lockDirectory ensureDeleteAll.
			self putInPlaceTheLockOf: mine ] ]
