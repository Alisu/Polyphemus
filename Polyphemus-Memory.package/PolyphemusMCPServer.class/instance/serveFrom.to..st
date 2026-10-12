serving
serveFrom: anInputStream to: anOutputStream

	"One message per line until the input ends; each answer on a line of its own, flushed at once."

	| line |
	[ (line := anInputStream nextLine) notNil ] whileTrue: [
		line isEmpty ifFalse: [
			(self answer: line) ifNotNil: [ :answer |
				anOutputStream
					nextPutAll: answer;
					lf;
					flush ] ] ]
