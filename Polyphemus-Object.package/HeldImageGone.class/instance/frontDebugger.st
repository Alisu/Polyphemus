handling
frontDebugger

	"The debugger whose window is in front, the one a button was pressed in; nil when none is."

	^ (self currentWorld submorphs
		   detect: [ :each |
			   (each respondsTo: #model) and: [
				   (each model respondsTo: #presenter) and: [ each model presenter class name = #StDebugger ] ] ]
		   ifNone: [ ^ nil ]) model presenter
