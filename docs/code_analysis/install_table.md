# Tool Installation Matrix

The following table consolidates canonical installation avenues for tooling used in code analysis, instrumentation, and runtime profiling. Installation methods favor distribution packages or language-specific ecosystems as recommended by each project's official documentation.

+-------------------+--------------------+--------------------------------------------------+
| Tool              | Installation Method| Example Command                                  |
+-------------------+--------------------+--------------------------------------------------+
| lizard            | pip                | pip install lizard                               |
| cloc              | apt                | sudo apt install cloc                            |
| cscope            | apt                | sudo apt install cscope                          |
| diffoscope        | pip                | pip install diffoscope                           |
| dtrace            | Source/Build       | git clone https://github.com/dtrace4linux/linux.git; cd linux; make; sudo make install |
| valgrind          | apt                | sudo apt install valgrind                        |
| cppcheck          | apt                | sudo apt install cppcheck                        |
| sloccount         | apt                | sudo apt install sloccount                       |
| flawfinder        | apt                | sudo apt install flawfinder                      |
| gdb               | apt                | sudo apt install gdb                             |
| pylint            | pip                | pip install pylint                               |
| flake8            | pip                | pip install flake8                               |
| mypy              | pip                | pip install mypy                                 |
| semgrep           | pip                | pip install semgrep                              |
| eslint            | npm                | npm install -g eslint                            |
| jshint            | npm                | npm install -g jshint                            |
| jscpd             | npm                | npm install -g jscpd                             |
| nyc               | npm                | npm install -g nyc                               |
+-------------------+--------------------+--------------------------------------------------+

Each entry traces back to the tool's authoritative distribution channel—PyPI for Python packages, npm for Node-based utilities, system package repositories for Debian derivatives, and official source repositories where no packaged alternative exists.
