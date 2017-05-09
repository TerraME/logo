
Random{seed = 12345}

import("logo")

p = PredatorPrey{}

p:run()

p.chart:save("predatorprey.bmp")
clean()

