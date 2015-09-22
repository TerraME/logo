
Random{seed = 12345}

import("logo")

sa = Sugarscape{finalTime = 40}

sa:execute()

sa.map:save("sugarscape.bmp")
clean()

