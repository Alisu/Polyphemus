walking
addressesOfClassIndex: anIndex from: anAddress upTo: aLimit ifCutShort: aBlock

	"Where every object of that class is between the two addresses, by one walk. A walk that damage
	ended before the limit is given to aBlock: what is answered is then of the heap before it (#211)."

	| found walk |
	found := OrderedCollection new.
	walk := self walkFrom: anAddress upTo: aLimit atMost: nil liveDo: [ :address :header |
		        (self classIndexIn: header) = anIndex ifTrue: [ found add: address ] ].
	walk reachedTheLimit ifFalse: [ aBlock value: walk ].
	^ found
