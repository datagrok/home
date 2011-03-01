/home/datagrok
====================================

I keep several things in my home directory under version control. I used to do this with CVS, then with Subversion, now with git.


Highlights
------------------------------------

- ``bin/acquire``: Walks up the parent heiarchy looking for a file.

- ``bin/subcommander``: A framework for collections of executables, like git.

- ``bin/changewatch``: Take some action when files change. A simple wrapper around inotify.

- ``bin/classpaths``: stupidly simple but I tear my hair without it when hacking Java. Colon-joins its arguments. ``bin/debjars`` is similar: a Debian-specific way to build a ``$CLASSPATH`` string out of system-installed .jar files.

- ``bin/{gcrl,uiop}``: a clever way to switch between keyboard layouts in a terminal.

- ``bin/giveto``: terminate a pipeline with this to dump stdin to a temporary file and hand that off to another program.

- ``bin/invirtualenv``: I like what ``virtualenv`` does, but I don't like how it does it. This is an attempt to do the same with a bit more Unix flavor. Works a bit like ``ssh-agent``.

- ``screen`` colors: ``etc/dotfiles/profile`` works with ``etc/dotfiles/screenrc`` to give each of my machines a differently-colored statusbar in ``screen``, and changes the command character on workstations to enable easy screen-inside-screen sessions.

- My prompt (``etc/dotfiles/bashrc``) will notice context information from several different places; running a subshell in an active virtualenv doesn't break.

- ``bin/pvgunzip`` smooshes together ``pv`` and ``gunzip`` to display a nice progress bar, showing statistics for the *uncompressed* data, when gunzipping a huge file.

- ``bin/renameall`` a poor-man's 'dired'; dumps all the filenames in the current directory into your text editor. Make your changes, save and exit, it does the work.

- ``bin/rmake`` run make, but look up the directory heiarchy for the Makefile the way ``ant -find`` does.

- ``bin/svnserve`` a technique to enable nice short, memorizable URLs for your subversion repositories.

- ``bin/update-dotfiles-svn`` if you adopt my directory structure, this handles the linking of dotfiles to their appropriate places in etc/dotfiles.


Directory Structure
------------------------------------

I don't wish to keep *everything* under my home directory in git. only my scripts in ``bin/``, various support files in ``lib/``, dotfiles, and other configuration in ``etc/``.

Rationale: were I to make ``~`` itself a git repository, I would need to craft tricky ``.gitignore`` settings to avoid pulling in lots of stuff that I don't want in version control. Also, there is a danger of using something like ``git clean`` in the wrong part of your directory tree and blowing away all your unversioned files.

To accomplish this, I keep a ``~/mnt`` directory, and within it all of my repository checkouts. Similar to a filesystem, ``git`` does not allow one to "checkout" (clone) only a subdirectory of a repository. So, I put all my working copies in one familiar place and then create convenient symlinks. Example::

    bin -> mnt/home/bin
    etc -> mnt/home/etc
    lib -> mnt/home/lib
    mnt/                                A place to keep checkouts of various VCS repositories.
        home-private/.git               A private repository of sensitive information
        home/.git                       **This repository**
            bin/
            etc/
                dotfiles/
            lib/
            README.md
        python-misc/.git
        ...
    usr/
    var/
        tmp/
    tmp/
    ...

Traditional dotfiles are replaced by symlinks into ``etc/dotfiles`` (actually ``mnt/home/etc/dotfiles``) with the leading dot removed. Example::

    ~/.bashrc -> mnt/home/etc/dotfiles/bashrc

TODO: Create a script that checks the home directory structure against this policy. (I already have one for managing dotfile symlinks, ``bin/update-dotfiles-svn``; update for new git-based structure and improve to manage directories and initial home directory setup as well.


Heirarchy
------------------------------------

I base this organizational scheme loosely on the `Filesystem Hierarchy Standard`_:

=============== ==============================================================
Directory       Purpose
=============== ==============================================================
bin/            A place for small standalone executables.

                Executables that are part of software packages that I have
                installed on a user-level without the system's package
                management system should live in ``~/usr/bin``.

etc/            Configuration settings.

etc/dotfiles/   Configuration "dotfiles", without the dot.

lib/            Standalone or in-development support files

                I tend to keep ``~/lib/python`` on my ``$PYTHONPATH``,
                ``~/lib/java`` in my ``$CLASSPATH``, and ``~/lib/latex2e`` in
                my ``$TEXINPUTS``. Then I can throw any support files that are
                universally useful into those paths and avoid copying them
                around from project to project.

mnt/            Checkouts of VCS repositories required by symlinks from my
                environment.

usr/            User-level software package installations; set as prefix when
                doing a ``make install``.

var/            Files whose content is expected to continually change
                during normal operation of the system--such as logs, spool
                files, and temporary e-mail files.

var/desktop/    Where nautilus keeps items that should be shown "on the desktop"

var/download/   Incoming unorganized download bucket for web browser, wget, etc.

var/local/      Locally cached copies of stuff otherwise easily available
                with a strong network connection. Assume it's no worse than
                slightly inconveinient to delete this whole folder at any time.
                (Similar to var/working; merge?)

var/log/        If a user-level script needs a logfile, keep it here.

var/mail/       Local mail storage (mutt)

var/pilot/      Palm pilot backups, resources

var/photos/     Incoming dumping ground for cameras. Photos are organized and
                moved to fileserver.

var/svn/        Subversion repositories hosted here, if any.

var/git/        Bare git repositories hosted here, if any.

var/tmp/        Temporary files to be preserved between reboots.

var/working/    Working-copy checkouts of various VCS repositories.

var/www/        Files to serve from this machine's webserver.
=============== ==============================================================

``tmp/`` vs. ``var/tmp/``: According to the `Filesystem Hierarchy Standard`_, ``/tmp/`` is usually cleared every boot, programs should not expect files to persist across invocations.  ``/var/tmp/`` does not clear at boot time, but may have files removed based on some policy like last-access. These same expectations will apply to ``~/tmp/`` and ``~/var/tmp/``.

``mnt/`` vs. ``var/working/``: I expect my environment to be up-to-date and working at all times. Keeping checkouts in ``mnt/`` makes it convenient to track changes when I make them, and adapt my directory structure to that of several disparate repositories. However, it is often unpleasant to do branching and merging in these same areas since checkout of different commits immediately affects (and can break) my environment. I suspect that it would be good to adopt this convention:

- track exactly one branch in all repos within ``mnt/``
- if needed, use a checkout of the same repo in ``var/working/`` to do branching and merging
- repos which I don't need to rely on as part of my environment (i.e. I make no symlinks into it) should go in ``var/working/``.

Initial setup
------------------------------------

TODO: instructions for moving into a new machine.


See Also
------------------------------------

There are several approaches to a home directory under version control; this one is mine. In no particular order:

- `Joey Hess: Subverting your homedir, or keeping your life in svn <http://kitenet.net/~joey/svnhome/>`_
- `VCS-Home <http://www.theficks.name/VCS-Home/HomePage>`_
- `eigenclass.org: A better backup system based on Git <http://eigenclass.org/hiki/gibak-backup-system-introduction>`_
- Interesting `comments on this blog <http://doug.warner.fm/d/blog/2008/07/Version-controlling-my-home-dir>`_: ``~`` as a working copy with the ``.git`` directory renamed and an alias to make git find it.
- There are so many blogs and pages discussing this that just `Googling will find something useful <http://www.google.com/search?sourceid=chrome&ie=UTF-8&q=home+directory+git>`_.

.. _Filesystem Hierarchy Standard: http://www.pathname.com/fhs/
