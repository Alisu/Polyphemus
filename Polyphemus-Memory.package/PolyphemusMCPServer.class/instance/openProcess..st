tools
openProcess: someArguments

	| pid reified handle |
	pid := someArguments at: 'pid' ifAbsent: [ self error: 'open_process needs a pid' ].
	reified := [ Polyphemus readProcess: pid ]
		           on: Error
		           do: [ :e | self error: 'Cannot read process ' , pid printString , ': ' , e messageText asString ].
	opened := (opened ifNil: [ 0 ]) + 1.
	handle := 'process' , opened printString.
	self images at: handle put: (Dictionary new
			 at: #pid put: pid;
			 at: #reified put: reified;
			 yourself).
	^ self
		  text: 'Read process ' , pid printString , ' as ' , handle , ': ' , (self processesOf: (self images at: handle)) size printString
			  , ' processes. It was held still while copied, at a quiet moment, then let go: this handle is that moment, and the image has run on since.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'pid' put: pid;
				   at: 'processes' put: (self processesOf: (self images at: handle)) size;
				   yourself)
