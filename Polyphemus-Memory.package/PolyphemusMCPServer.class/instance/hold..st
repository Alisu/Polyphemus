tools
hold: someArguments

	"Hold a running image on what it is busy with, in its own debugger, our watcher put in first
	if none waits there (#128). The handle steps it until let_go."

	| pid directory session handle |
	pid := someArguments at: 'pid' ifAbsent: [ self error: 'hold needs a pid' ].
	directory := (someArguments at: 'directory' ifAbsent: [ nil ])
		             ifNil: [ FileLocator temp / 'polyphemus-hold' / pid printString ]
		             ifNotNil: [ :path | path asFileReference ].
	session := [
	           Polyphemus putAWatcherInto: pid watchedIn: directory.
	           Polyphemus holdProcess: pid watchedIn: directory ]
		           on: Error
		           do: [ :e | self error: 'Cannot hold process ' , pid printString , ': ' , e messageText asString ].
	opened := (opened ifNil: [ 0 ]) + 1.
	handle := 'held' , opened printString.
	self images at: handle put: (Dictionary new
			 at: #pid put: pid;
			 at: #session put: session;
			 yourself).
	^ self held: handle saying: 'Held process ' , pid printString , ' as ' , handle , ', on what it was busy with. It stays held until let_go.'
