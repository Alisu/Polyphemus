naming
symbolAt: anAddress

	"The library's file name and the nearest function's name (nil if none) holding anAddress
	here (dladdr); nil when no library holds it."

	| info |
	info := MacProcessMemory pinned: 32.
	(MacProcessMemory dladdr: anAddress into: info) = 0 ifTrue: [ ^ nil ].
	^ (ExternalAddress fromAddress: (info unsignedLongLongAt: 1)) utf8StringFromCString asFileReference basename
	  -> ((info unsignedLongLongAt: 17) = 0 ifFalse: [
			   (ExternalAddress fromAddress: (info unsignedLongLongAt: 17)) utf8StringFromCString ])
