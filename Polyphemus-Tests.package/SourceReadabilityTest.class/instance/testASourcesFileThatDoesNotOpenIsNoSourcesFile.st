tests
testASourcesFileThatDoesNotOpenIsNoSourcesFile

	"#118: beside the image, a link named as a sources file and leading nowhere. It was taken for
	the sources file, and reading a method's source then failed in Pharo's own code, on a stream
	that is nil. It is no sources file: said so, and a method's source is empty."

	| memory link |
	OSPlatform current isWindows ifTrue: [ ^ self skip: 'no dangling link is made on Windows' ].
	link := (self class directory / 'gone.sources') fullName.
	LibC runCommand: 'ln -s /nowhere/at/all.sources "' , link , '"'.
	memory := self class memory.
	[
	self assert: (memory sourceReadability whyNot: #source) equals: #noSourcesFile.
	self
		assert: ((memory oopClassNamed: 'Point') methodNamed: 'x' ifAbsent: [ self fail: 'no Point>>x' ]) getSourceFromFile
		equals: '' ] ensure: [ LibC runCommand: 'rm -f "' , link , '"' ]
