accessing
form

	^ form ifNil: [ form := self draw ]
