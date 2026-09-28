compiling
parserClass

	"This host's parser: RBParser up to Pharo 12, OCParser from Pharo 13; Pharo 14 drops the
	old name."

	^ Smalltalk globals at: #OCParser ifAbsent: [ Smalltalk globals at: #RBParser ]
