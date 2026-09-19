tests
testThePinnedImageReadsAsItsOwnSource

	"Beside its own .sources and no .changes, which once left no source at all (#16)."

	| memory |
	LibC system: 'ln -s ' , (PharoImageAccessor pathToPharo10 asFileReference parent
		 / 'cleanP10.sources') fullName , ' ' , (self class directory / 'alone.sources') fullName.
	memory := self class memory.

	self assert: memory sourceReadability refusals asArray equals: #(  ).
	self assert: (memory sourceReadability canRead: #source)
