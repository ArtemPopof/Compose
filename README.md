# Compose
Creating music with ease
<br>
<br>
<br>
## Installation

### Dependencies

You'll need the following dependencies to build:

* libgranite-dev
* libgtk-3-dev
* libasound2-dev
* meson
* valac

### Building

```bash
meson build --prefix=/usr
cd build
ninja
```

### Installing & executing

To install, use `ninja install`, then execute with `com.github.abbysoft-team.compose`.

```bash
sudo ninja install
com.github.artempopof.compose
```
