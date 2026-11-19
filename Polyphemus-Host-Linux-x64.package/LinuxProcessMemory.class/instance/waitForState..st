holding it still
waitForState: aLetter

	"Signals are delivered when the kernel gets round to it, not when the call returns."

	^ Poll until: [ self state = aLetter ] every: 20 milliSeconds atMost: 100
