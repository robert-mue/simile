# simile

A schema-driven **diagram editor** for declarative modelling — the application
that will replace the diagram editor of [Simile](https://simulistics.com). It is
built on **[sienna](https://github.com/robert-mue/sienna)**, a static jQuery
shell (menu + workspace + panels, with an action log, undo/redo and replay),
included here as a git submodule.

Design notes and decisions live in **[DESIGN-diagram.md](DESIGN-diagram.md)**.

## Getting the code

This repo uses a submodule for the shell, so clone recursively:

```
git clone --recurse-submodules https://github.com/robert-mue/simile.git
```

If you already cloned without `--recurse-submodules`:

```
git submodule update --init
```

## Running

No build, no server, no dependencies to install. Just open the file:

```
Double-click index.html  (or:  google-chrome index.html)
```

`index.html` loads the shell from `sienna/` and this app's scripts from `src/`.
The diagram widget is not built yet — for now you get the shell's menu and
workspace as a skeleton.

## Updating the shell

To pull a newer sienna into this app:

```
git submodule update --remote sienna
git add sienna && git commit -m "Bump sienna submodule"
```
