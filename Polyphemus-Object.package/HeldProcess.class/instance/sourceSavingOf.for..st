private
sourceSavingOf: aSource for: aReifiedMethod

	"For the image to keep the source a method was just saved from, as any save does (Pharo 14 with
	other words): in its changes file, the method pointing there. A variable trailer grows by
	becomeForward:, whose forwarders a full collection takes out, before the next read (#105)."

	| method preamble |
	method := self methodNameOf: aReifiedMethod.
	preamble := aReifiedMethod oopMethodClass oopName , ' methodsFor: ''polyphemus'' stamp: ''Polyphemus''!'.
	^ '| method |
method := ' , method , '.
(method respondsTo: #putSource:withPreamble:)
	ifTrue: [
		method
			putSource: ' , aSource printString , '
			withPreamble: [ :stream | stream cr; nextPut: $!; nextPutAll: ' , preamble printString , '; cr ] ]
	ifFalse: [
		method
			putSource: ' , aSource printString , '
			withFooter: ''''
			protocol: ([ method protocol name asString ] on: Error do: [ :e | ''polyphemus'' ])
			timestamp: DateAndTime now asString
			priorSourcePointer: 0 ].
' , ((reading methodTrailerClass == OOPVariableMethodTrailer) ifTrue: [ 'Smalltalk garbageCollect.
' ] ifFalse: [ '' ]) , 'nil'
