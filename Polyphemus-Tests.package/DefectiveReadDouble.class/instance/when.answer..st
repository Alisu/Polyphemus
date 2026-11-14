accessing
when: aSelector answer: aBlock

	"From now on aSelector answers aBlock's value, in place of what the object it stands for does."

	replies at: aSelector put: aBlock
