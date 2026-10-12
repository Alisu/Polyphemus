tools
lineOfFrame: aRow

	^ String streamContents: [ :s |
		  s << (aRow at: 'frame') printString << '  ' << (aRow at: 'method').
		  (aRow at: 'statement') ifNotNil: [ :statement | s << '  at: ' << statement ].
		  (aRow at: 'temporaries') do: [ :each |
			  s << '  ' << ((each at: 'name') ifNil: [ '?' ]) << '=' << (each at: 'value') ].
		  (aRow at: 'note') ifNotNil: [ :note | s << '  (' << note << ')' ] ]
