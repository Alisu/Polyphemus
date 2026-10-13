writing
machine

	"e_machine: AArch64 (183) on arm64, x86-64 (62) otherwise; the observer reads a process on
	its own machine."

	^ PolyphemusHost current cpu = 'arm64'
		  ifTrue: [ 183 ]
		  ifFalse: [ 62 ]
