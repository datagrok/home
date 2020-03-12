# ~datagrok/

I keep several things in my home directory under version control.
Dotfiles, little scripts, little libraries, etc.

I used to do this with CVS,
then with Subversion and a complicated [bespoke symlink-management tool](https://github.com/datagrok/home/blob/66d9758bc9745c3c69130c198ab868a7df5419f6/bin/update-dotfiles-svn),
then with git and an improved complicated bespoke symlink-management tool,
now with git, some clever configuration, and no symlinks.

## Mechanism

1. `$HOME` is the root of a git work tree.
2. To avoid accidentally committing most files, place [`/*` in `.gitignore`](https://github.com/datagrok/home/blob/master/.gitignore#L10). 
3. To avoid having every git invocation discover a root at `$HOME`, relocate the git directory by explicitly specifying `$GIT_DIR`.
4. To avoid using a bash alias that inserts `--git-dir` as an argument, create [a custom git subcommand](https://github.com/datagrok/home/blob/master/bin/git-home) that explicitly sets `$GIT_DIR`.
5. To avoid specifying `--work-dir` as an argument or environment variable, set it into the repository configuration.
   `git home config core.worktree $HOME`

Downsides:

- bash completion doesn't work with `git home ...`.

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
