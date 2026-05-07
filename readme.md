# shfolio

A portfolio that is also a shell. A shell that is also a lie. A lie that tells the truth.

shfolio is a single HTML file that boots a fake Unix system in the browser, presents a CRT terminal with phosphor glow, scanlines, and grain noise, and lets the visitor navigate a complete fake filesystem using real shell commands. It is a GitHub Pages site. It has no server, no framework, no dependencies, and no build step. Everything runs in the visitor's browser from a single `index.html`.

The filesystem is not a metaphor. It has inodes, permissions, owners, mtimes, symlinks, hidden files, and a `/proc` that reports the visitor's actual CPU architecture, core count, and browser. `uname -a` fingerprints the visitor's machine and returns a formatted kernel string. `cat /proc/cpuinfo` reads real hardware concurrency from the browser. The system knows what it is running on.

The shell is not a prompt wrapper. It parses `&&` and `||`, maintains a working directory, resolves relative and absolute paths, implements tab completion over both commands and the filesystem tree, and keeps a navigable history. It is called `sh` because that is what it is.


## Why

A CV lists projects. A shell lets you explore them.

The difference is the same as the difference between reading a man page and running the program. One is a description of a thing. The other is the thing. shfolio attempts to be the thing.

There is also a less defensible reason. Every tool in this portfolio, the microkernel, the interpreters, the compilers, the libc, the jail, was built because the standard version existed but building it yourself is the only honest way to understand it. A portfolio page built with React and a template would be coherent with nothing. A portfolio page that is itself a systems artifact is at least coherent with the work it describes.

> **Note:** The fake filesystem contains real content. The READMEs under `/home/root/projects/` are the actual project descriptions. The BF programs under `/home/root/projects/compilers/bfelfx64/` are real Brainfuck source. `cat /etc/passwd` says something worth reading. `ls -la /root/.secrets/` requires knowing to look.


## Features

- CRT phosphor display with layered bloom glow, scanline overlay, radial vignette, animated canvas grain noise at 120ms, and a 9-second screen flicker cycle.
- Block cursor blinking at exactly 530ms, the classical terminal rate.
- systemd style boot sequence with randomized kernel timestamps, real project names, and `[  OK  ]` confirmation lines. Skippable on any keypress. `localStorage` remembers returning visitors and skips straight to login.
- Visitor hardware fingerprinting via `navigator.userAgent`, `navigator.hardwareConcurrency`, and `navigator.platform`. `uname -a` and `cat /proc/cpuinfo` return real data about the visitor's machine.
- Complete fake filesystem: `/`, `/bin`, `/boot`, `/etc`, `/proc`, `/dev`, `/root`, `/usr`, `/var`, `/tmp`. Every node has type, permissions, owner, size, and mtime. Symlinks resolve. Hidden files require `-a`.
- Shell with path resolution, `&&` and `||` operators, command history with arrow navigation, tab completion on commands and paths, `Ctrl+C`, `Ctrl+L`.
- Brainfuck interpreter executable against any `.bf` file in the filesystem via `bf <file.bf> [input]`. The interpreter is the same linked list tape implementation from the `bfelfx64` project, infinite in both directions, 8-bit wrapping, pre computed bracket maps, EOF returns 0.
- Hidden easter eggs reachable only by exploration.


## Filesystem Layout

```
/
├── bin/          sh ls cat cd pwd echo grep ps file bf uname whoami id man readelf systrace mem help
├── boot/         cell_os.elf  grub.cfg  MANIFEST
├── dev/          null  zero  random  urandom -> /dev/random  tty1
├── etc/          passwd  shadow  hostname  os-release  fstab  proof.conf
├── proc/         1/  cpuinfo  meminfo  version
├── root/
│   ├── .bashrc           (hidden)
│   ├── .proof_history    (hidden)
│   ├── .secrets/         (hidden)
│   │   ├── README
│   │   ├── thompson.txt
│   │   └── rop_notes.txt
│   ├── books/
│   │   ├── malloc_to_godel.txt
│   │   └── cell_os_book.txt
│   └── projects/
│       ├── kernel/        cell_os/
│       ├── languages/     slug/  snail/
│       ├── compilers/     bfelfx64/  sh2elf/
│       ├── security/      linker0trust/  crt0trust/  elfmutator/  rop/  isol8r/
│       ├── systems/       libc/  tortoise/
│       └── tools/         oldbox/  diff/  duet/  prand/  terminax/  syscalls/
├── tmp/
├── usr/
│   ├── bin/      toolbox  sbpm  scb
│   └── share/man/man1/    bf.1  cell_os.1  sh.1
└── var/log/      cell_os.log  proof.log
```


## Shell Commands

```
ls [-la] [path]          list directory contents
cat <file>               print file to stdout
cd <path>                change directory
pwd                      print working directory
file <path>              identify file type
bf <file.bf> [input]     execute brainfuck program
man <command>            display manual page
readelf <file>           display ELF header information
ps                       list running processes
uname [-a]               system information
whoami                   current user
id                       uid gid groups
hostname                 system hostname
echo [args]              print arguments
history                  command history
clear / Ctrl+L           clear screen
Ctrl+C                   interrupt
exit / logout            reboot, runs full boot sequence again
```


## Brainfuck Integration

Any `.bf` file in the filesystem is executable:

```
bf /home/root/projects/compilers/bfelfx64/hello.bf
bf /home/root/projects/compilers/bfelfx64/echo.bf Hello
bf /home/root/projects/compilers/bfelfx64/rot13.bf Hello
bf /home/root/projects/compilers/bfelfx64/fib.bf
```

The interpreter uses a doubly linked list as the tape, growing in both directions on demand. This is more correct than implementations that error on leftward overflow. Cell values are 8-bit unsigned with wrapping. Bracket matching is pre computed before execution. The `,` command returns 0 on EOF, which is one of the three standard conventions and the most useful one for pipelines.

The BF source files in the filesystem are real programs. They run. The output is correct.

> **Note:** `bfelfx64`, the actual project, compiles Brainfuck directly to raw x86-64 ELF binaries with no assembler and no libc. What runs in shfolio is an interpreter, not a compiler. The compiler cannot run in a browser. This is the correct architectural decision and also a reminder that a simulation of a thing is not the thing.


## CRT Rendering

The phosphor effect is layered rather than flat. Text glow uses three shadow radii at 2px, 8px, and 20px with decreasing opacity, approximating the bloom fall off of real phosphor. New lines animate from a bright overexposed state back to resting glow over 90ms, simulating phosphor excitation. The scanline overlay is a repeating gradient at 3px pitch with 18% opacity. The vignette is a radial gradient darkening the corners where a real CRT tube would curve away. The grain is a canvas redrawn every 120ms with random per-pixel green channel noise at 5% opacity. The flicker is a 9-second sinusoidal opacity cycle at ±3%, below the threshold of conscious perception but present in peripheral vision. The cursor blinks at exactly 530ms using `step-end` timing so it snaps rather than fades.

None of this is necessary. It is also not decorative. A phosphor terminal is what the tools in this portfolio ran on when the ideas behind them were first worked out. The aesthetic is not nostalgia. It is context.


## Implementation Notes

The filesystem is a plain JavaScript object tree. Every node carries its metadata inline. Path resolution handles `.` and `..` correctly, grows the working directory string, and never touches the DOM. Tab completion walks the same tree. The shell prompt updates on every `cd` and reflects `~` for `/root` and `~/subpath` for anything under it, matching standard shell behavior.

The boot sequence timestamps are generated at page load from a monotonically increasing float with random increments, producing realistic burst-then-pause kernel message timing. The `[  OK  ]` lines come after with a longer delay, matching real systemd behavior where services confirm after the kernel finishes talking.

`localStorage` is the only persistent state. It stores one key: whether the visitor has booted before. Nothing else is tracked. Nothing else is stored. There is no analytics, no telemetry, no external requests except the font.

The font is VT323, loaded via `@font-face` with `font-display:swap` directly from the Google Fonts CDN without the CSS intermediary. The fallback stack is `monospace`. If the font is blocked, by Brave shields, by a strict CSP, by an offline network, the terminal renders in the system monospace font and nothing else breaks. The layout does not depend on the font being present.

The entire portfolio is one file. It has no build step, no bundler, no framework, no npm, no CI, no Docker, no Kubernetes, no cloud. It is an HTML file. You open it in a browser.


## Suggested Exploration

```sh
help
uname -a
cat /proc/cpuinfo
cat /etc/passwd
cat /etc/shadow
ls -la /root
ls -la /root/.secrets
cat /root/.secrets/thompson.txt
cat /root/books/malloc_to_godel.txt
ls /root/projects/security
cat /root/projects/security/linker0trust/README
cat /root/projects/security/crt0trust/README
bf /home/root/projects/compilers/bfelfx64/hello.bf
bf /home/root/projects/compilers/bfelfx64/rot13.bf "Hello, World"
cat /var/log/proof.log
cat /boot/MANIFEST
man bf
exit
```

The site will be living at `https://gaidardzhiev.github.io/shfolio/`

## License

Copyright (C) 2026 Ivan Gaydardzhiev. Licensed under GPL-3.0-only; see [COPYING](./COPYING) for details.
