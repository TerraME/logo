
Random{seed = 12345}

import("logo")

lab = Labyrinth{finalTime = 15}

lab:execute()

lab.map:save("labyrinth.bmp")
clean()

