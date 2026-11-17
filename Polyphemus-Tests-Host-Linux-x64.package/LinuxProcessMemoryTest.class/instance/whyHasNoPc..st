helpers
whyHasNoPc: aFrame

	"Which of pc's ways out gave nil (#62): a machine code frame its layout cannot map, no
	instruction pointer, or VMMaker's conversion failing."

	^ String streamContents: [ :s |
		  | ip |
		  s nextPutAll: aFrame class name , ', machine code '.
		  s print: ([ aFrame isMachineCodeFrame ] on: Error do: [ :e | e messageText ]).
		  s nextPutAll: ', layout reads machine code pcs '.
		  s print: ([ aFrame readsMachineCodePC ] on: Error do: [ :e | e messageText ]).
		  s nextPutAll: ', active '.
		  s print: ([ aFrame isActiveFrame ] on: Error do: [ :e | e messageText ]).
		  ip := [ aFrame instructionPointer ] on: Error do: [ :e | 'ERR ' , e messageText ].
		  s nextPutAll: ', instruction pointer '.
		  ip isInteger ifTrue: [ s nextPutAll: '16r' , ip printStringHex ] ifFalse: [ s print: ip ].
		  s nextPutAll: ', method '.
		  s print: ([ aFrame method printString ] on: Error do: [ :e | e messageText ]).
		  ip isInteger ifTrue: [
			  s nextPutAll: ', conversion: '.
			  s print: ([ aFrame layout contextPCOf: ip frame: (aFrame instVarNamed: #framePointer) ]
					   on: Error do: [ :e | 'ERR ' , e class name , ' ' , e messageText ]) ] ]
