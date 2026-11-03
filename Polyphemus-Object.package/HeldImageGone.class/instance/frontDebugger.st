handling
frontDebugger

	"The debugger on a reading whose window is in front, the one a button was pressed in; nil when
	none is."

	^ (self currentWorld submorphs
		   detect: [ :each |
			   (each respondsTo: #model) and: [
				   (each model respondsTo: #presenter) and: [ each model presenter class name = #PolyphemusDebugger ] ] ]
		   ifNone: [ ^ nil ]) model presenter
