private
hasTheHeldProcessesHeaderAt: anAddress in: aReading

	"Whether the header there, read from the copy, is of an object with the held process's hash and
	of Process's class. After a collection the address may hold anything: nothing is made of it
	before this says yes (#212)."

	| scanner header |
	dumped ifNil: [ ^ false ].
	scanner := dumped raw scanner.
	header := [ scanner headerAt: anAddress ] on: PolyphemusError do: [ :refusal | nil ].
	^ header notNil and: [
		  (SpurHeader hashOf: header) = hash and: [
			  (scanner classIndexIn: header) = (aReading oopClassNamed: 'Process') oopHash ] ]
