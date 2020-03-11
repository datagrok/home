# ~datagrok/

I keep several things in my home directory under version control.
Dotfiles, little scripts, little libraries, etc.

I used to do this with CVS,
then with Subversion and a complicated bespoke symlink-management tool,
then with git and an improved complicated bespoke symlink-management tool,
now with git, some clever configuration, and no symlinks.

## Mechanism

1. `$HOME` is the root of a git work tree.
2. To avoid accidentally committing most files, place `/*` in `.gitignore`.
3. To avoid having every git invocation discover a root at `$HOME`, relocate the git directory by explicitly specifying `$GIT_DIR`.
4. To avoid using a bash alias that inserts --git-dir as an argument, create a custom git subcommand that sets `$GIT_DIR`.
5. To avoid specifying --work-dir as an argument or environment variable, set it into the repository configuration.

I was inspired by techniques demonstrated in:

- Drew DeVault's Blog, [Managing my dotfiles as a git repository][1] (2019-12-30)
- Ferry Boender's Blog, [Keep your home dir in Git with a detached working directory][2] (2015-06-22)

[1]: https://drewdevault.com/2019/12/30/dotfiles.html
[2]: https://www.electricmonk.nl/log/2015/06/22/keep-your-home-dir-in-git-with-a-detached-working-directory/

## Highlights

- `bin/changewatch`: Take some action when files change. A simple wrapper around inotify.

- `bin/classpaths`: stupidly simple but I tear my hair without it when hacking Java. Colon-joins its arguments. `bin/debjars` is similar: a Debian-specific way to build a `$CLASSPATH` string out of system-installed .jar files. Another way is `ls -1 | paste -sd:`

- `bin/giveto`: terminate a pipeline with this to dump stdin to a temporary file and hand that off to another program.

- `screen` colors: `etc/dotfiles/profile` works with `etc/dotfiles/screenrc` to give each of my machines a differently-colored statusbar in `screen`, and changes the command character on workstations to enable easy screen-inside-screen sessions.

- My prompt (`etc/dotfiles/bashrc`) will notice context information from several different places; running a subshell in an active virtualenv doesn't break.

- `bin/pvgunzip` smooshes together `pv` and `gunzip` to display a nice progress bar, showing statistics for the *uncompressed* data, when gunzipping a huge file.

- `bin/renameall` a poor-man's 'dired'; dumps all the filenames in the current directory into your text editor. Make your changes, save and exit, it does the work.

- `bin/rmake` run make, but look up the directory heiarchy for the Makefile the way `ant -find` does.

- `bin/svnserve` a technique to enable nice short, memorizable URLs for your subversion repositories.

## Heirarchy

I base this organizational scheme loosely on the [Filesystem Hierarchy Standard][]:

```
=============== ==============================================================
Directory       Purpose
=============== ==============================================================
bin/            A place for small standalone executables.

                Executables that are part of software packages that I have
                installed on a user-level without the system's package
                management system should live in `~/usr/bin`.

etc/            Configuration settings.

lib/            Standalone or in-development support files

                I tend to keep `~/lib/python` on my `$PYTHONPATH`,
                `~/lib/java` in my `$CLASSPATH`, and `~/lib/latex2e` in
                my `$TEXINPUTS`. Then I can throw any support files that are
                universally useful into those paths and avoid copying them
                around from project to project.

usr/            User-level software package installations; set as prefix when
                doing a `make install`.

var/            Files whose content is expected to continually change
                during normal operation of the system--such as logs, spool
                files, and temporary e-mail files.

var/desktop/    Where nautilus keeps items that should be shown "on the desktop"

var/download/   Incoming unorganized download bucket for web browser, wget, etc.

var/local/      Locally cached copies of stuff otherwise easily available
                with a strong network connection. Assume it's no worse than
                slightly inconveinient to delete this whole folder at any time.

var/log/        If a user-level script needs a logfile, keep it here.

var/mail/       Local mail storage

var/photos/     Incoming dumping ground for cameras. Photos are organized and
                moved to fileserver.

var/svn/        Subversion repositories hosted here, if any.

var/git/        Bare git repositories hosted here, if any.

var/tmp/        Temporary files to be preserved between reboots.

var/www/        Files to serve from this machine's webserver.
=============== ==============================================================
```

`tmp/` vs. `var/tmp/`: According to the [Filesystem Hierarchy Standard][], `/tmp/` is usually cleared every boot, programs should not expect files to persist across invocations.  `/var/tmp/` does not clear at boot time, but may have files removed based on some policy like last-access. These same expectations will apply to `~/tmp/` and `~/var/tmp/`.

## Initial setup

TODO: instructions for moving into a new machine.

## See Also

There are several approaches to a home directory under version control; this one is mine. In no particular order:

- [Joey Hess: Subverting your homedir, or keeping your life in svn](http://kitenet.net/~joey/svnhome/)
- [VCS-Home](http://www.theficks.name/VCS-Home/HomePage)
- [eigenclass.org: A better backup system based on Git](http://eigenclass.org/hiki/gibak-backup-system-introduction)
- Interesting [comments on this blog](http://doug.warner.fm/d/blog/2008/07/Version-controlling-my-home-dir): `~` as a working copy with the `.git` directory renamed and an alias to make git find it.

[Filesystem Hierarchy Standard]: http://www.pathname.com/fhs/
