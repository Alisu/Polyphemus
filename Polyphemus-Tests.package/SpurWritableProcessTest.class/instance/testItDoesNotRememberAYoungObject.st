tests
testItDoesNotRememberAYoungObject

	"The remembered set holds old objects only: a young one there is left behind by the next
	scavenge, the entry then pointing at garbage (a lead for #119)."

	self deny: (memory remember: 16r10200).
	self assert: (memory wordAt: 16r10200) equals: 0.
	self assert: (memory variables at: 'rememberedSetSize') equals: 0
