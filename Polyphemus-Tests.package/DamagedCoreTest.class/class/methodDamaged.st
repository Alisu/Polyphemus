accessing
methodDamaged

	"The method of the damaged copy whose header was overwritten; nil where the clean core had
	no Interval>>first."

	| memory |
	memory := self memory.
	^ (Damaged at: #methodHeader ifAbsent: [ ^ nil ]) in: [ :address | memory reifyOop: address ]
