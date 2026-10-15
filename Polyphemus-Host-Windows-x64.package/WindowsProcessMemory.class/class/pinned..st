library
pinned: aSize

	"A buffer C may write into: pinned, so a collection cannot move it during the call."

	^ (ByteArray new: aSize) pinInMemory; yourself
