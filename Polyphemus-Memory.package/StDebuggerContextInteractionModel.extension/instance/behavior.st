*Polyphemus-Memory
behavior

	"Which class the code pane reads the source against: the receiver's, as Pharo does,
	but the receiver's class in the image being analysed rather than the class of the
	reified object in ours, which is OOPRegularObject and explains nothing."

	self context class == OOPContext ifTrue: [
		^ [ (self context receiver oopClass) ifNil: [ self context method methodClass ] ]
			  on: Error
			  do: [ :e | [ self context method methodClass ] on: Error do: [ :e2 | nil ] ] ].
	^ self context receiver class
