accessing
endOfInstructionAt: anOffset

	"The offset just past the instruction starting at anOffset."

	^ starts detect: [ :each | each > anOffset ] ifNone: [ SmallInteger maxVal ]
