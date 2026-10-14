reading
nameOfSymbolAt: anEntry strings: aStringTable

	"Eight bytes inline, or, when the first four are zero, an offset into the string table."

	| end |
	(self unsignedIn: self bytes at: anEntry size: 4) = 0 ifTrue: [
		^ self stringAt: aStringTable + (self unsignedIn: self bytes at: anEntry + 4 size: 4) ].
	end := (1 to: 8) detect: [ :i | (self bytes at: anEntry + i) = 0 ] ifNone: [ 9 ].
	^ (self bytes copyFrom: anEntry + 1 to: anEntry + end - 1) asString
