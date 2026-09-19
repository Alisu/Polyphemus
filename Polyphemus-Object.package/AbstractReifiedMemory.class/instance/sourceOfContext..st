contexts
sourceOfContext: anActivation

	"The source of the activation's method from the target's .sources, or nil. A block uses
	its home method's source. None when the sources found are not this image's."

	(self sourceReadability canRead: #source) ifFalse: [ ^ nil ].

	^ [ (self homeMethodOf: anActivation compiledCode) sourceCode ]
		  on: Error
		  do: [ :e | nil ]
