helpers
stateOf: aPid

	"As ps says it: T stopped, S or R running, empty once gone."

	^ (LibC resultOfCommand: 'ps -o stat= -p ' , aPid printString) trimBoth
