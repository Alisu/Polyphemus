tools
openCore: someArguments

	| path reified handle |
	path := someArguments at: 'path' ifAbsent: [ self error: 'open_core needs a path' ].
	path asFileReference isFile ifFalse: [ self error: 'No core file at ' , path ].
	reified := Polyphemus readCoreDump: path.
	opened := (opened ifNil: [ 0 ]) + 1.
	handle := 'core' , opened printString.
	self images at: handle put: (Dictionary new
			 at: #path put: path;
			 at: #reified put: reified;
			 yourself).
	^ self
		  text: 'Opened ' , path , ' as ' , handle , ': ' , (self processesOf: (self images at: handle)) size printString
			  , ' processes. Read from the file; nothing ran.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'path' put: path;
				   at: 'processes' put: (self processesOf: (self images at: handle)) size;
				   yourself)
