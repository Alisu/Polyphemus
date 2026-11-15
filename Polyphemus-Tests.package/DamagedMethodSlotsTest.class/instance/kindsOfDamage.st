running
kindsOfDamage

	"What a slot can hold after damage, each named, with the word it then holds."

	^ {
		  ('a tagged word' -> 16r29).
		  ('the address of nothing' -> 16rFFE9797400).
		  ('an object of another kind' -> process address).
		  ('the method itself' -> subject address).
		  ('an object whose class does not read' -> victim address) }
