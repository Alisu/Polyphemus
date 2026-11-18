locking
underTheGuardDo: aBlock

	"aBlock's value while this observer alone takes the lock. The guard is a directory made aside
	and renamed into place, which fails where one is: another's is waited for a second, and one
	older than guardAge, left by an observer that died there, is taken away."

	| guard fresh tries |
	guard := directory / 'hold.lock.taking'.
	fresh := directory / ('hold.lock.taking-' , UUID new asString).
	fresh ensureCreateDirectory.
	(fresh / 'by') writeStreamDo: [ :stream | stream print: self hosts ownPid ].
	tries := 0.
	[ [ fresh renameTo: guard basename. true ] on: FileSystemError , PrimitiveFailed do: [ :taken | false ] ] whileFalse: [
		(guard exists and: [ (DateAndTime now - guard modificationTime) > self guardAge ])
			ifTrue: [ guard ensureDeleteAll ]
			ifFalse: [
				(tries := tries + 1) > 50 ifTrue: [
					fresh ensureDeleteAll.
					^ HoldFailed signal: 'another observer is taking the lock of ' , directory fullName ].
				(Delay forMilliseconds: 20) wait ] ].
	^ aBlock ensure: [ guard ensureDeleteAll ]
