tools
hold: someArguments

	"Hold a running image on what it is busy with, in its own debugger, our watcher put in first
	if none waits there (#128). The handle steps it until let_go."

	| pid directory session handle |
	pid := someArguments at: 'pid' ifAbsent: [ ToolCallFailed signal: 'hold needs a pid' ].
	directory := (someArguments at: 'directory' ifAbsent: [ nil ])
		             ifNil: [ self defaultHoldDirectoryFor: pid ]
		             ifNotNil: [ :path | path asFileReference ].
	session := [
	           Polyphemus putAWatcherInto: pid watchedIn: directory.
	           Polyphemus holdProcess: pid watchedIn: directory ]
		           on: PolyphemusError , FileSystemError
		           do: [ :e | ToolCallFailed signal: 'Cannot hold process ' , pid printString , ': ' , e messageText asString ].
	handle := self open: (PolyphemusMCPReading held: pid session: session) as: 'held'.
	^ self held: handle saying: 'Held process ' , pid printString , ' as ' , handle , ', on what it was busy with. It stays held until let_go.'
