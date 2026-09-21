accessing
tell: aNotifier that: aMessage

	"Say why the edit was not made, where whoever asked can see it, and answer false so the
	pane keeps what was typed."

	aNotifier
		ifNil: [ UIManager default inform: aMessage ]
		ifNotNil: [
			[ aNotifier notify: aMessage ]
				on: Error
				do: [ :error | UIManager default inform: aMessage ] ].
	^ false
