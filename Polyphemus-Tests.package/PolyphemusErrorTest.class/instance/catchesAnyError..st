running
catchesAnyError: aMethod

	"Whether it holds a handler of every Error: on: Error do:, on: Error , another do:, or one
	of the two shorthands for it."

	^ aMethod ast sendNodes anySatisfy: [ :node |
		  (#( #onErrorDo: #ifError: ) includes: node selector) or: [
			  node selector = #on:do: and: [
				  | caught |
				  caught := node arguments first.
				  (caught isVariable and: [ caught name = #Error ]) or: [
					  caught isMessage and: [ caught receiver isVariable and: [ caught receiver name = #Error ] ] ] ] ] ]
