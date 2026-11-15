damages
damagesOfTrailersIn: aCleanReading

	"The last four bytes of three more methods of Interval, each made a trailer embedding source
	that does not decode (#118): sum's wide, anyOne's zipped, reverseDo:'s compressed."

	| endOf |
	endOf := [ :name |
	         self
		         endOf: ((aCleanReading oopClassNamed: 'Interval') methodNamed: name ifAbsent: [ self error: 'no Interval>>' , name ])
		         in: aCleanReading ].
	^ {
		  ((endOf value: 'sum') - 4 -> #[ 255 254 2 48 ]).
		  ((endOf value: 'anyOne') - 4 -> #[ 255 254 2 28 ]).
		  ((endOf value: 'reverseDo:') - 4 -> #[ 0 16rC0 1 24 ]) }
