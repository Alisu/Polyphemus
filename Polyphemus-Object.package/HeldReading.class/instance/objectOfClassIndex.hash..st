reading
objectOfClassIndex: anIndex hash: aHash

	"The object of that class with that identity hash in a new copy of the image, nil if none."

	| address |
	self readAgain.
	address := dumped objectOfClassIndex: anIndex hash: aHash.
	^ address ifNotNil: [ reading reifyOop: address ]
