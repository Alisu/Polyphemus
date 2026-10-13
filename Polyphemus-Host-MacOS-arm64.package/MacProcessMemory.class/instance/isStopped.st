testing
isStopped

	^ (LibC resultOfCommand: 'ps -o stat= -p ' , pid printString) trimBoth beginsWith: 'T'
