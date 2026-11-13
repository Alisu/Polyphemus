reflective operations
doesNotUnderstand: aMessage

	"A test failure is no Error: a catch-all handler around the sender does not hide it."

	^ TestFailure new signal: 'I was asked ' , aMessage selector printString , ', and should be asked nothing'
