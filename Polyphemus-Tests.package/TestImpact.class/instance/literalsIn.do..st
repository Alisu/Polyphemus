private
literalsIn: aCompiledCode do: aBlock

	"Its literals, those of its blocks and of its literal arrays too: a block names its own, which
	Pharo's searches find as the method's (#131)."

	aCompiledCode literals do: [ :literal | self literal: literal do: aBlock ]
