helpers
processesOf: aPid

	"Each process of the target as a failure should show it: name, priority, the frame it is at and
	the list it is in -- the counter run, waiting, suspended or evicted (#119)."

	^ [ String streamContents: [ :stream |
		    (Polyphemus readProcess: aPid) allReifiedProcesses do: [ :each |
			    stream
				    nextPutAll: ([ Polyphemus nameOfProcess: each ] on: Error do: [ :e | '?' ]) asString;
				    nextPutAll: ' at ';
				    nextPutAll: ([ each priority printString ] on: Error do: [ :e | '?' ]);
				    nextPutAll: ' in ';
				    nextPutAll: ([ each suspendedContext printString ] on: Error do: [ :e | '?' ]);
				    nextPutAll: ' on ';
				    nextPutAll: ([ each myList oopClassName ] on: Error do: [ :e | 'nothing' ]) asString;
				    nextPutAll: '; ' ] ] ]
		  on: Error
		  do: [ :error | 'cannot read its processes: ' , error messageText asString ]
