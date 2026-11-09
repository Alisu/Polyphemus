reading
nameOfMethodType: anInteger

	"Cog's name for what a CogMethod is (a method, a closed or open inline cache), else the number."

	^ #( #CMMethod #CMClosedPIC #CMOpenPIC #CMFree )
		  detect: [ :each | ((Cogit bindingOf: each) ifNotNil: [ :binding | binding value ]) = anInteger ]
		  ifFound: [ :each | 'a ' , (each allButFirst: 2) asString ]
		  ifNone: [ 'type ' , anInteger printString ]
