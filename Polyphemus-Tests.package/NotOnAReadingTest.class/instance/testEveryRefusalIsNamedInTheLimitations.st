tests
testEveryRefusalIsNamedInTheLimitations

	"What a held image refuses was said in three classes, each its own way: said in one, and that
	one in step with what users read (#118)."

	| limitations |
	limitations := (self repositoryDirectory / 'docs' / 'limitations.md') contents.
	NotOnAReading refusals keysAndValuesDo: [ :key :refusal |
		self assert: (limitations includesSubstring: refusal key) description: key , ': ' , refusal key ]
