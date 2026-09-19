reading
readSymbols: aTable strings: aStringTable

	"Each entry is 24 bytes: name offset, info, other, section index, value, size. A section
	index of 0 is an undefined symbol; an info whose low four bits are 1 is a variable."

	| strings |
	strings := aStringTable at: 2.
	(aTable at: 2) to: (aTable at: 2) + (aTable at: 3) - 24 by: 24 do: [ :offset |
		| at nameOffset name |
		at := offset + 1.
		nameOffset := ElfNote unsignedFrom: self bytes at: at size: 4.
		(nameOffset > 0 and: [ (ElfNote unsignedFrom: self bytes at: at + 6 size: 2) ~= 0 ])
			ifTrue: [
				name := self stringAt: strings + nameOffset + 1.
				symbols at: name put: (ElfNote unsignedFrom: self bytes at: at + 8 size: 8).
				((self bytes at: at + 4) bitAnd: 15) = 1 ifTrue: [ variableNames add: name ] ] ]
