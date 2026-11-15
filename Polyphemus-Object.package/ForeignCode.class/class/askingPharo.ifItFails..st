asking
askingPharo: aBlock ifItFails: anotherBlock

	"aBlock's value, which sends to Pharo's own compiler, parser, scopes, variables or decoders. Whatever
	they raise, a syntax error's notification included (no Error up to Pharo 12, #29), the value
	of anotherBlock, which may take what was raised."

	^ aBlock
		  on: Error , (Smalltalk globals at: #SyntaxErrorNotification ifAbsent: [ Error ])
		  do: [ :raised | anotherBlock cull: raised ]
