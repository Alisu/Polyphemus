context protocol
findContextSuchThat: testBlock

	"Search self and my sender chain for the first one that satisfies testBlock. Answers nil
	if none satisfy."

	^ memory stacks findFrom: self suchThat: testBlock
