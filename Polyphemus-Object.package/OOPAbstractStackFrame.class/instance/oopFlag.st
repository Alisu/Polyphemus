accessing
oopFlag

	"Its flags: how many arguments, whether it has a context, whether it runs a block. Refused by
	name where they do not read."

	^ flags ifNil: [ self layout flagsOf: framePointer ]
