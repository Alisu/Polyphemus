running
sessionNoting: aCollection

	"A debug session's double: what it is asked to run until, to let go or to stop is added to
	aCollection, and it is on no context."

	^ (DefectiveReadDouble of: Object new)
		  when: #runUntil:within: answer: [ :method :duration | aCollection add: method -> duration. true ];
		  when: #letTheImageGo answer: [ aCollection add: #letGo ];
		  when: #stopTheHeldProcess answer: [ aCollection add: #stopped ];
		  when: #interruptedContext answer: [ nil ];
		  yourself