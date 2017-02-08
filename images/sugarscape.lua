
Random{seed = 12345}

import("logo")

sa = Sugarscape{finalTime = 40}

sa:run()

sa.map2:save("sugarscape.bmp")
clean()

