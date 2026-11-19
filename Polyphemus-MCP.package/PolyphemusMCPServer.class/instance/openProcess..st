tools
openProcess: someArguments

	| pid reading handle |
	pid := someArguments at: 'pid' ifAbsent: [ ToolCallFailed signal: 'open_process needs a pid' ].
	reading := [ PolyphemusMCPReading process: pid ]
		           on: PolyphemusError , FileSystemError
		           do: [ :e | ToolCallFailed signal: 'Cannot read process ' , pid printString , ': ' , e messageText asString ].
	handle := self open: reading as: 'process'.
	^ self
		  text: 'Read process ' , pid printString , ' as ' , handle , ': ' , reading processes size printString
			  , ' processes. It was held still while copied, at a quiet moment, then let go: this handle is that moment, and the image has run on since.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'pid' put: pid;
				   at: 'processes' put: reading processes size;
				   yourself)
