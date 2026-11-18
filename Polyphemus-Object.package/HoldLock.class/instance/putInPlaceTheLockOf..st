locking
putInPlaceTheLockOf: aPid

	"The lock made beside its place, naming its owner, then renamed into it: there whole or not at all."

	| fresh |
	fresh := directory / ('hold.lock-' , UUID new asString).
	fresh ensureCreateDirectory.
	(fresh / 'owner') writeStreamDo: [ :stream | stream print: aPid ].
	[ fresh renameTo: self lockDirectory basename ] on: FileSystemError , PrimitiveFailed do: [ :error |
		fresh ensureDeleteAll.
		HoldFailed signal: 'cannot lock ' , directory fullName , ': ' , error messageText asString ]
