tools
openCore: someArguments

	| path handle |
	path := someArguments at: 'path' ifAbsent: [ ToolCallFailed signal: 'open_core needs a path' ].
	path asFileReference isFile ifFalse: [ ToolCallFailed signal: 'No core file at ' , path ].
	handle := self open: (PolyphemusMCPReading core: path) as: 'core'.
	^ self
		  text: 'Opened ' , path , ' as ' , handle , ': ' , (self images at: handle) processes size printString
			  , ' processes. Read from the file; nothing ran.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'path' put: path;
				   at: 'processes' put: (self images at: handle) processes size;
				   yourself)
