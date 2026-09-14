enumerating
do: aBlock

	"A reified string has to answer enough of the String protocol to be written to a
	stream: the debugger prints selectors and messages that live in the other image."

	self asString do: aBlock
