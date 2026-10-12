tools
imageAt: someArguments

	| handle |
	handle := someArguments at: 'handle' ifAbsent: [ self error: 'This tool needs the handle open_image answered' ].
	^ self images at: handle ifAbsent: [ self error: 'No image opened as ' , handle printString , '; open one with open_image' ]
