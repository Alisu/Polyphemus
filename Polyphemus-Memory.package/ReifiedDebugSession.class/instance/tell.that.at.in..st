accessing
tell: aNotifier that: aMessage at: aPosition in: aSource

	"Say why the edit was not made where whoever asked sees it -- a code pane in the code, at that
	position (#108) -- and answer false so the pane keeps what was typed."

	aNotifier ifNil: [
		UIManager default inform: aMessage.
		^ false ].
	[
	(aNotifier respondsTo: #notify:at:in:)
		ifTrue: [ aNotifier notify: aMessage at: aPosition in: aSource ]
		ifFalse: [ aNotifier notify: aMessage ] ]
		on: Error
		do: [ :error | UIManager default inform: aMessage ].
	^ false
