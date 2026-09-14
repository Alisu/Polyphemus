building the fixture
corruptedImagePath

	"An image damaged the way a damaged image really is: bytes in the file are wrong.

	Every other test that reads damage injects it through our own API and puts it back in
	an ensure:, which only ever proves that we can read what we just wrote. This one is
	written into a copy of the file, by something that is not the reader, and is never
	repaired."

	| clean corrupted |
	clean := PharoImageAccessor pathToPharo10 asFileReference.
	corrupted := clean parent / 'cleanP10-blanked-context.image'.
	corrupted exists ifFalse: [ self buildBlankedCopyFrom: clean to: corrupted ].
	^ corrupted fullName
