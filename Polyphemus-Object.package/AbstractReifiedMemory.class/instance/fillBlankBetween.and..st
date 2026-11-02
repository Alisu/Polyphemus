accessing
fillBlankBetween: anAddress and: anotherAddress

	| abnormalEntity nextOop max supposedNextObjectAddress actualNextObjectAddress sizeBetweenSupposedAndActual previousObjectAddress |
	"The objects should be contiguous, freeChunk are also represented by objects any disconstinuity is abnormal.
Since we foundOop through roots we have great chance to miss entire object graph leaving blanks
"
	actualNextObjectAddress := anAddress.
	max := anotherAddress.
	[ 
	nextOop := self findObjectAfter: actualNextObjectAddress.
	actualNextObjectAddress < max and: [ nextOop isNotNil ] ] whileTrue: [ 
		
		previousObjectAddress := actualNextObjectAddress.
		supposedNextObjectAddress := memory objectAfter:
			                             actualNextObjectAddress.
		actualNextObjectAddress := nextOop address.
		sizeBetweenSupposedAndActual := actualNextObjectAddress
		                                - supposedNextObjectAddress.
		"An object running over the next one found is the abnormal one (#139)"
		sizeBetweenSupposedAndActual < 0 ifTrue: [
			supposedNextObjectAddress := previousObjectAddress.
			sizeBetweenSupposedAndActual := actualNextObjectAddress - previousObjectAddress ].

		sizeBetweenSupposedAndActual = 0 ifFalse: [ 
			abnormalEntity := OOPAbnormalEntity
				                  newFor: supposedNextObjectAddress
				                  size: sizeBetweenSupposedAndActual
				                  on: self.
			self objectAt: abnormalEntity address put: abnormalEntity ] ]