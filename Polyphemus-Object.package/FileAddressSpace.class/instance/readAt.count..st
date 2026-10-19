private
readAt: anOffset count: aCount

	"Straight from the file. Near the end it answers what there is, which is fewer bytes than
	asked for; the callers above check what they are entitled to before asking."

	| buffer read |
	buffer := ByteArray new: aCount.
	self stream position: anOffset.
	read := self stream readInto: buffer startingAt: 1 count: aCount.
	^ read = aCount ifTrue: [ buffer ] ifFalse: [ buffer copyFrom: 1 to: read ]
