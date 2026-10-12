tools
rowOfFrame: anActivation numbered: aNumber

	"Temporaries by name where this host lays the method out as the image did (#6); otherwise
	by number, with a note saying why."

	| names count temporaries note node |
	names := [ anActivation tempNames asArray ] on: Error do: [ :e | #(  ) ].
	count := names
		         ifEmpty: [ [ anActivation method numTemps ] on: Error do: [ :e | 0 ] ]
		         ifNotEmpty: [ names size ].
	temporaries := (1 to: count) collect: [ :i |
		               Dictionary new
			               at: 'name' put: (names at: i ifAbsent: [ nil ]);
			               at: 'value' put: ([ self describe: (anActivation tempAt: i) ] on: Error do: [ :e | '(unreadable)' ]);
			               at: 'address' put: ([ self addressOf: (anActivation tempAt: i) ] on: Error do: [ :e | nil ]);
			               yourself ].
	(names isEmpty and: [ count > 0 ]) ifTrue: [
		note := 'temporaries not named: this host does not compile this method as the image did (#6); the edition made for that image names them' ].
	node := [ anActivation sourceNodeExecuted ] on: Error do: [ :e | nil ].
	^ Dictionary new
		  at: 'frame' put: aNumber;
		  at: 'method' put: anActivation printString;
		  at: 'statement' put: ((node isNil or: [ node isKindOf: OOPUnknownSourceNode ])
				   ifTrue: [ nil ]
				   ifFalse: [ [ node sourceCode ] on: Error do: [ :e | nil ] ]);
		  at: 'receiver' put: ([ self describe: anActivation receiver ] on: Error do: [ :e | '(unreadable)' ]);
		  at: 'receiverAddress' put: ([ self addressOf: anActivation receiver ] on: Error do: [ :e | nil ]);
		  at: 'temporaries' put: temporaries asArray;
		  at: 'note' put: note;
		  yourself
