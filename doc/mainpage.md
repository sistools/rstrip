# rstrip {#mainpage}

**rstrip** is a small, standalone utility that removes trailing whitespace
from each input line.


## Components

| Unit | File(s) | Summary |
| ---- | ------- | ------- |
| Public API | `rstrip.h`, `rstrip.c` | Version macros and `sistool_rstrip()` |
| Program entry | `entry.c` | Command-line handling and program lifecycle |


## API

The `sistool_rstrip()` function reads from an input stream, removes trailing
whitespace from each line, and writes the result to an output stream.


<!-- ########################### end of file ########################### -->
