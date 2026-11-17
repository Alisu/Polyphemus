tools
rowOfFrame: anActivation numbered: aNumber

	"Temporaries by name where this host lays the method out as the image did (#6), each read by
	its name: the names in scope are not the frame's slots in order (#191). Otherwise by number,
	with a note saying why."

	| names count temporaries note node |
	names := [ anActivation tempNames asArray ] on: PolyphemusError do: [ :e | #(  ) ].
	count := names
		         ifEmpty: [ [ anActivation method numTemps ] on: PolyphemusError do: [ :e | 0 ] ]
		         ifNotEmpty: [ names size ].
	temporaries := names
		               ifEmpty: [
		               (1 to: count) collect: [ :i | self rowOfTemporary: nil readBy: [ anActivation tempAt: i ] ] ]
		               ifNotEmpty: [
		               names collect: [ :each | self rowOfTemporary: each readBy: [ anActivation tempNamed: each ] ] ].
	(names isEmpty and: [ count > 0 ]) ifTrue: [
		note := 'temporaries not named: this host does not compile this method as the image did (#6); the edition made for that image names them' ].
	node := [ anActivation sourceNodeExecuted ] on: PolyphemusError do: [ :e | nil ].
	^ Dictionary new
		  at: 'frame' put: aNumber;
		  at: 'method' put: anActivation printString;
		  at: 'statement' put: ((node isNil or: [ node isKindOf: OOPUnknownSourceNode ])
				   ifTrue: [ nil ]
				   ifFalse: [ [ node sourceCode ] on: PolyphemusError do: [ :e | nil ] ]);
		  at: 'receiver' put: ([ self describe: anActivation receiver ] on: PolyphemusError do: [ :e | '(unreadable)' ]);
		  at: 'receiverAddress' put: ([ self addressOf: anActivation receiver ] on: PolyphemusError do: [ :e | nil ]);
		  at: 'temporaries' put: temporaries asArray;
		  at: 'note' put: note;
		  yourself
