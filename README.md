## Basic SmartOS Winbind Setup Script and Configuration Files

This repository is a summary of steps taken and configurations used in this blog series:

1. [Winbind in SmartOS, Part I (the Basics)](https://ops.faithlife.com/?p=52)
2. [Winbind in SmartOS, Part II (Running in Base-64)](https://ops.faithlife.com/?p=136)
3. [Winbind in SmartOS, Part III (Polishing)](https://ops.faithlife.com/?p=179)

The [setup.sh](setup.sh) script is a summary of all command-line steps taken in the series and can be used for **testing purposes** in your environment. No error checking is implemented and an environment of base-64 version 15.2.0+ is assumed, for the sake of readability, so this script is **not recommended for production use**. Adaptation of this script to your choice of configuration management solution is recommended.
