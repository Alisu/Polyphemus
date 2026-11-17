private
readAt: anOffset count: aCount

	"Straight from the file. Near the end it answers what there is, which is fewer bytes than
	asked for; the callers above check what they are entitled to before asking. No more is made
	room for than the file holds from there: a count read from a damaged file may be anything (#211)."

	| buffer read opened wanted |
	opened := self stream.
	wanted := aCount min: (opened size - anOffset max: 0).
	buffer := ByteArray new: wanted.
	opened position: anOffset.
	read := opened readInto: buffer startingAt: 1 count: wanted.
	^ read = wanted ifTrue: [ buffer ] ifFalse: [ buffer copyFrom: 1 to: read ]
