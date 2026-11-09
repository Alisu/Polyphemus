reading
nameOfAnnotation: anInteger

	"Cog's name for a map annotation, as its pools hold it, else the number."

	^ #( #IsObjectReference #IsAbsPCReference #IsRelativeCall #HasBytecodePC #IsSendCall #IsNSSendCall
	     #IsSuperSend #IsDirectedSuperSend #IsDirectedSuperBindingSend #IsNSSelfSend #IsNSDynamicSuperSend
	     #IsNSImplicitReceiverSend )
		  detect: [ :each | ((Cogit bindingOf: each) ifNotNil: [ :binding | binding value ]) = anInteger ]
		  ifNone: [ 'annotation ' , anInteger printString ]
