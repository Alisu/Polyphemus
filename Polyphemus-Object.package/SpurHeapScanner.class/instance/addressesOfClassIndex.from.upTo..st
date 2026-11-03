walking
addressesOfClassIndex: anIndex from: anAddress upTo: aLimit

	"Where every object of that class is between the two addresses, by one walk."

	| found |
	found := OrderedCollection new.
	self walkFrom: anAddress upTo: aLimit atMost: nil liveDo: [ :address :header |
		(self classIndexIn: header) = anIndex ifTrue: [ found add: address ] ].
	^ found
