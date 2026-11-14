running
kindsOfDamage

	"What a slot can hold after damage, each named, with the word it then holds."

	^ {
		  ('a tagged word' -> [ :context | 16r29 ]).
		  ('the address of nothing' -> [ :context | 16rFFE9797400 ]).
		  ('an object of another kind' -> [ :context | process address ]).
		  ('the context itself' -> [ :context | context address ]).
		  ('an object whose class does not read' -> [ :context | victim address ]) }
