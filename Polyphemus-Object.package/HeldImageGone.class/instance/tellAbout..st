handling
tellAbout: aDebuggerOrNil

	"Ask, until answered, whether to close the debugger that was reading the gone image; kept, its
	title says the image is gone for as long as it stays open (#142)."

	(UIManager default confirm: self messageText trueChoice: 'Close the debugger' falseChoice: 'Keep the debugger open')
		ifTrue: [ aDebuggerOrNil ifNotNil: [ :debugger | debugger close ] ]
		ifFalse: [
			aDebuggerOrNil ifNotNil: [ :debugger |
				debugger withWindowDo: [ :window | window title: '[Image gone] ' , window title ] ] ]
