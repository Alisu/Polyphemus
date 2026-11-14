running
layoutWhoseVariablesFailIn: aSelector

	"A layout of Cog on the same core, whose VM variables have a defect of our own where
	aSelector is answered."

	| raw variables |
	raw := memory vmLayout raw.
	variables := (DefectiveReadDouble of: raw vmVariables) when: aSelector answer: [ 1 / 0 ].
	^ OOPCogLayout on: memory raw: ((DefectiveReadDouble of: raw) when: #vmVariables answer: [ variables ])
