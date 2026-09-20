editing
codeAt: anAddress ofSize: aCount

	"The bytes the file holds there, to check against the code a method was compiled from."

	^ (1 to: aCount) collect: [ :each | self raw space unsignedAt: anAddress + each - 1 size: 1 ]
