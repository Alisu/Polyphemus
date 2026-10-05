printing
descriptionAs: aSummary

	^ String streamContents: [ :s |
		  s nextPutAll: 'thread ' , id printString , ' (' , state , '): ' , aSummary.
		  pc ifNotNil: [ s nextPutAll: ', pc 16r' , pc printStringHex , ' in ' , self location ].
		  (arguments notNil and: [ arguments notEmpty and: [ self systemCallName notNil ] ]) ifTrue: [
			  s nextPutAll: ', first argument ' , arguments first printString ] ]
