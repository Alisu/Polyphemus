tools
openImage: someArguments

	| path memory census handle |
	path := someArguments at: 'path' ifAbsent: [ self error: 'open_image needs a path' ].
	path asFileReference isFile ifFalse: [ self error: 'No image file at ' , path ].
	memory := (Polyphemus interpreterOnImageFile: path) objectMemory.
	census := HeapCensus of: memory.
	opened := (opened ifNil: [ 0 ]) + 1.
	handle := 'image' , opened printString.
	self images at: handle put: (Dictionary new
			 at: #path put: path;
			 at: #memory put: memory;
			 at: #census put: census;
			 yourself).
	^ self
		  text: 'Opened ' , path , ' as ' , handle , ': ' , census objectCount printString , ' objects, '
			  , census bytes printString , ' bytes of old space. Read from the file; nothing ran in it.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'path' put: path;
				   at: 'objects' put: census objectCount;
				   at: 'bytes' put: census bytes;
				   yourself)
