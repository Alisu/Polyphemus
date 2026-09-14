contexts
descriptionOfFrame: aFrame

	"A frame reads like the context it would become: the class of its receiver and the
	selector of the method it runs, with a note when what runs is a block."

	| method home |
	method := [ aFrame oopMethod ] on: Error do: [ :e | nil ].
	method ifNil: [ ^ 'a frame whose method cannot be read' ].
	home := [ self homeMethodOf: method ] on: Error do: [ :e | method ].

	^ ([ aFrame oopReceiver oopClassName ] on: Error do: [ :e | 'an unreadable receiver' ])
	  , '>>'
	  , ([ home oopSelector asString ] on: Error do: [ :e | 'an unreadable selector' ])
	  , (([ method isCompiledBlockOop ] on: Error do: [ :e | false ])
			   ifTrue: [ ' [block]' ]
			   ifFalse: [ '' ])
