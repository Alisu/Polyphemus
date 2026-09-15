context protocol
findContextSuchThat: testBlock

	"Search self and my sender chain for the first one that satisfies testBlock. Answers nil
	if none satisfy."

	^ memory findFrom: self suchThat: testBlock
