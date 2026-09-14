initialization
initializePresenters

	"The display blocks have to be in place before the widgets are built: setting one
	on a list that is already on screen does not reach the adapter."

	processList := self newList.
	processList display: [ :process | self labelForProcess: process ].
	frameList := self newList.
	frameList display: [ :context | reifiedMemory descriptionOfContext: context ].
	sourceText := self newText.
	sourceText beNotEditable
