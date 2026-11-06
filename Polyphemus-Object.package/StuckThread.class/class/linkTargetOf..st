reading
linkTargetOf: aPath

	"What a symbolic link says, as it says it, or nil: /proc links a descriptor to pipe:[123], which
	is no path for Pharo to resolve (#159)."

	| buffer count |
	buffer := ByteArray new: 4096.
	count := self readlink: aPath into: buffer size: buffer size.
	^ count < 0
		  ifTrue: [ nil ]
		  ifFalse: [ (buffer first: count) asString ]
