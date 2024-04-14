local function TestFunctionSpeed(Name, Function, ...)
	local Start									= tick()

	Function(...)

	print(tick() - Start, Name)
end

local Random	= Random.new()

TestFunctionSpeed("Math.Random", math.random, 1, 1)
TestFunctionSpeed("Random Integer", Random.NextInteger, Random, 1, 1)