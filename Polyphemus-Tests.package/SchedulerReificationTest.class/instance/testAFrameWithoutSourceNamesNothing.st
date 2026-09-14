tests
testAFrameWithoutSourceNamesNothing

	"Names live in the source, never in the objects: a context holds values in order and
	nothing else. This image carries no source for its methods, so there is nothing to
	analyse and nothing to name.

	What it must not do is name them anyway. A method whose source is gone can still be
	decompiled, and the decompilation calls them arg1 and tmp1 -- names this image made
	up, that nobody wrote and that mean nothing to whoever is reading the image."

	| frame |
	frame := (reifiedMemory contextsOfProcess: reifiedMemory reifiedActiveProcess) first.

	self assert: frame tempNames isEmpty.
	self should: [ frame tempNamed: 'anything' ] raise: Error
