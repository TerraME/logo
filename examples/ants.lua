
-- @example A scenario for the Ants model. It uses 50 agents with evaporation rate
-- 0.5 and diffusion rate 5.

import("logo")

ants = Ants{
	societySize = 50,
	rateDiffusion = 5,
	rateEvaporation = 0.5
}

ants:run()

