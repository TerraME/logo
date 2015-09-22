
Random{seed = 12345}

import("logo")

sa = SingleAgent{finalTime = 15}

sa:execute()

sa.map:save("single-agent.bmp")
clean()

