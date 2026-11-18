tests
testTheDefaultHoldDirectoryIsTheProcesssOwnersAlone

	"#180: hold with no directory used one under the shared temporary directory, made without
	looking at who owned it, and the held image evaluates the do.st it finds there. It is made for
	the user the process runs as and closed to others; one open to others is refused."

	| pid directory |
	OSPlatform current isWindows ifTrue: [ ^ self skip: 'the modes and owners asked are those of Linux and macOS' ].
	pid := PolyphemusMadeFor current processMemoryClass ownPid.
	directory := self server defaultHoldDirectoryFor: pid.
	[
	self assert: directory isDirectory.
	self assert: ((LibC resultOfCommand: 'ls -ldn ''' , directory fullName , '''') first: 10) equals: 'drwx------'.
	self assert: (self server defaultHoldDirectoryFor: pid) equals: directory.
	LibC system: 'chmod 777 ''' , directory fullName , ''''.
	self should: [ self server defaultHoldDirectoryFor: pid ] raise: ToolCallFailed ] ensure: [ directory ensureDeleteAll ]
