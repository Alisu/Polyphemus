tests
testTwoRunsFetchingOneImageAtOnceBothLeaveItWhole

	"Test classes run side by side, and on a fresh checkout two of them may fetch one pinned
	image at once (#74): from a file, twice at once, the image arrives once and whole."

	| directory resources zip script |
	directory := PolyphemusEdition current scratch / 'polyphemus-fetch-test'.
	directory ensureDeleteAll.
	resources := (directory / 'resources') ensureCreateDirectory.
	zip := directory / 'Fake.zip'.
	zip binaryWriteStreamDo: [ :stream |
		ZipArchive new
			addString: 'image' as: 'Fake.image';
			addString: 'changes' as: 'Fake.changes';
			addString: 'sources' as: 'Fake-64bit.sources';
			writeTo: stream ].
	script := directory / 'twice.sh'.
	script writeStreamDo: [ :stream |
		#( 'one' 'two' ) do: [ :each |
			stream
				nextPutAll: '(';
				nextPutAll: (PharoImageAccessor fetchCommandFrom: 'file://' , zip fullName named: 'cleanFake' into: resources fullName);
				nextPutAll: '; touch ' , each , '.done) &';
				lf ] ].

	"The VM's children see wait return at once: each fetch says when it is done."
	LibC runCommand: 'cd ' , directory fullName , ' && sh twice.sh'.
	600 timesRepeat: [
		((directory / 'one.done') exists and: [ (directory / 'two.done') exists ]) ifFalse: [
			(Delay forMilliseconds: 100) wait ] ].

	self
		assert: (resources children collect: [ :each | each basename ]) asSortedCollection asArray
		equals: #( 'cleanFake.changes' 'cleanFake.image' 'cleanFake.sources' ).
	self assert: (resources / 'cleanFake.image') contents equals: 'image'.
	self
		assert: (directory children collect: [ :each | each basename ]) asSortedCollection asArray
		equals: #( 'Fake.zip' 'one.done' 'resources' 'twice.sh' 'two.done' )
