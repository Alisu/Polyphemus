saving
tell: aMessage at: aPosition

	"Say why the source was not saved where the one who accepted it sees it -- a code pane in the
	code, at that position and followed by ' ->' as Pharo does (#108) -- and answer false."

	told := aMessage.
	notifier ifNil: [
		UIManager default inform: aMessage.
		^ false ].
	[
	(notifier respondsTo: #notify:at:in:)
		ifTrue: [ notifier notify: aMessage , ' ->' at: aPosition in: source ]
		ifFalse: [ notifier notify: aMessage ] ]
		on: Error
		do: [ :error | UIManager default inform: aMessage ].
	^ false
