printing
titleMark

	"What a debugger's title says of this thread blocked in a C call (#18)."

	^ 'In C: ' , self systemCallName , (waitsOn ifNil: [ '' ] ifNotNil: [ ', waiting on ' , waitsOn ])
