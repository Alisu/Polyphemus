setting
when: aSelector answer: aBlock

	"From now on aSelector answers aBlock's value, in place of what the object it stands for
	does; a block with parameters is given the message's arguments."

	replies at: aSelector put: aBlock
