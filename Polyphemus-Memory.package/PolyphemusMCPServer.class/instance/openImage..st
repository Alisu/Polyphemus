tools
openImage: someArguments

	| path reading census handle |
	path := someArguments at: 'path' ifAbsent: [ ToolCallFailed signal: 'open_image needs a path' ].
	path asFileReference isFile ifFalse: [ ToolCallFailed signal: 'No image file at ' , path ].
	reading := PolyphemusMCPReading imageFile: path.
	census := reading census.
	handle := self open: reading as: 'image'.
	^ self
		  text: 'Opened ' , path , ' as ' , handle , ': ' , census objectCount printString , ' objects, '
			  , census bytes printString , ' bytes of old space. Read from the file; nothing ran in it.'
		  structured: (Dictionary new
				   at: 'handle' put: handle;
				   at: 'path' put: path;
				   at: 'objects' put: census objectCount;
				   at: 'bytes' put: census bytes;
				   yourself)
