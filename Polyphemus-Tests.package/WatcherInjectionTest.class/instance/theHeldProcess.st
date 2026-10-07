helpers
theHeldProcess

	"Asked of the held image when the held process is not the busy one: which one it is."

	^ '| process | process := self at: #process. process priority printString , '' '' , process name printString , '' '' , process suspendedContext printString'
