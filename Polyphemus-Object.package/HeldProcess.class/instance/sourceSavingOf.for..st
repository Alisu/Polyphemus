private
sourceSavingOf: aSource for: aReifiedMethod

	"For the image to keep the source a method was just saved from, as any save does: in its changes
	file, the method pointing there. A variable trailer is grown by becomeForward:, whose forwarders
	a full collection takes out, so that what is read next is the method itself (#105)."

	| method preamble |
	method := aReifiedMethod oopMethodClass oopName , ' >> #' , aReifiedMethod oopSelector asString.
	preamble := aReifiedMethod oopMethodClass oopName , ' methodsFor: ''polyphemus'' stamp: ''Polyphemus''!'.
	^ '(' , method , ')
	putSource: ' , aSource printString , '
	withPreamble: [ :stream | stream cr; nextPut: $!; nextPutAll: ' , preamble printString , '; cr ].
' , ((reading methodTrailerClass == OOPVariableMethodTrailer) ifTrue: [ 'Smalltalk garbageCollect.
' ] ifFalse: [ '' ]) , 'nil'
