# Learn Perl 6 Online

A simple Perl 6 tutorial system that lets users try out Perl 6 without
installing it on their own system first. The interface is fairly (there's an
understatement for ya) JavaScript-heavy so that it's got an easy-to-get-to
tutorial sidebar, and the Perl 6 compilation/execution runs over websockets.

Security note - right now there really isn't any - it simply runs the same
Perl 6 compiler that the main application uses. Before actually running this
on any live server, please give a thought to where the Perl 6 compiler(s) will
be located, and ideally run the perl6 compiler that's accepting user input
in a chroot'ed iron box with CPU and RAM limitations.

Eventually there will be a separate server that you can spawn inside a chroot
server.

This is heavily cribbed from jnthn's cro+react+redux tutorial, jnthn++.

Aside from the React/Redux stuff for websockets, it uses MUI for the
sidebar containing lesson plans, and eventually MUI styling for the buttons
and whatever else I can get working.

It's inspired by learn.golang.org, which is a very simple set of tutorial pages
and access to a Go compiler. I've changed the look-and-feel somewhat, but I
would love to have someone with a better eye for UI go over it.

Installation
============

```
zef install --/test cro
```
(the `--/test' builds the `cro' binary as well as loads its modules.)

And then, after cloning this repository, and changing into its directory, do:

```
zef install --depsonly .
npm install .
npm run build
cro run
```
