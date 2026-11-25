reading
contextPCOfMachineCodePC: anEncodedPC method: aMethodAddress inABlock: aBoolean

	"CoInterpreter>>mustMapMachineCodePC:context:: a context Cog took off a machine code frame keeps
	its CogMethod's address less the pc, mapped as a frame's is (#215); nil once returned from."

	| cogMethodAddress mcpc header start bytecodePC skip |
	anEncodedPC = -1 ifTrue: [ ^ nil ].
	cogMethodAddress := (self cogMethodAddressOf: aMethodAddress) ifNil: [
		^ self refuse: #itsPcIsMachineCodeOfAMethodNotCompiled ].
	mcpc := cogMethodAddress - anEncodedPC.
	header := self methodHeaderOf: aMethodAddress.
	start := self startPCOfMethodHeader: header.
	bytecodePC := mcpc - cogMethodAddress < (self cogit cogMethodSurrogateAt: cogMethodAddress) stackCheckOffset
		ifTrue: [ start ]
		ifFalse: [ (self bytecodePCOf: mcpc inCogMethodAt: cogMethodAddress) ifNil: [ ^ nil ] ].
	(bytecodePC = start and: [ aBoolean not ]) ifTrue: [
		skip := ForeignCode
			        askingVMMaker: [
				        (memory interpreter methodHeaderHasPrimitive: header)
					        ifTrue: [ memory interpreter sizeOfCallPrimitiveBytecode: header ]
					        ifFalse: [ 0 ] ]
			        ifItFails: [ ^ nil ].
		bytecodePC := bytecodePC + skip ].
	^ bytecodePC + 1
