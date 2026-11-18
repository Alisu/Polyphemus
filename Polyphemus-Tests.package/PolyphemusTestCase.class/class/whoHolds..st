helpers
whoHolds: anObject

	"For a failure's description: each object that points to anObject, by class; a context with the
	methods under it, which name the process that still runs with it."

	^ [
	  String streamContents: [ :stream |
		  (anObject pointersTo reject: [ :each | each class == WeakArray ]) do: [ :each |
			  stream nextPutAll: ' | '; nextPutAll: each class name.
			  (each isKindOf: Context) ifTrue: [
				  | frame |
				  frame := each.
				  14 timesRepeat: [
					  frame ifNotNil: [
						  stream nextPutAll: ' < '; nextPutAll: ([ frame method methodClass name , '>>' , frame method selector ] on: Error do: [ :e | '?' ]).
						  frame := frame sender ] ] ] ] ] ]
		  on: Error
		  do: [ :e | ' (who holds it could not be told: ' , e messageText asString , ')' ]
