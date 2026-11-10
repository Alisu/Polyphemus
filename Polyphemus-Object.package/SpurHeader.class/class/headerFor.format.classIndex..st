making
headerFor: aCount format: aFormat classIndex: anIndex

	"A header without hash or flags; a count of 255 or more goes in the word before."

	^ ((aCount min: 255) bitShift: 56) + (aFormat bitShift: 24) + anIndex
