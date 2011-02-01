# ~datagrok

I keep several things in my home directory under version control. I used to do this with CVS, then with Subversion, now with git.

## Directory Structure

I don't wish to keep *everything* under my home directory in git. only my scripts in `bin/`, various support files in `lib/`, dotfiles, and other configuration in `etc/`. Rationale: were I to make `~` itself a git repository, I would need to craft tricky `.gitignore` settings to avoid pulling in lots of stuff that I don't want in version control. Also, there is a danger of using something like `git clean` in the wrong part of your directory tree and blowing away all one's unversioned files.

To accomplish this, I will create a ~/mnt directory and keep within it all of my repository checkouts. Similar to a filesystem, `git` does not allow one to "checkout" (clone) a subdirectory of a repository. So, I put all my working copies in one familiar place and then create convenient symlinks.

In `~`:

	bin -> mnt/home/bin
	etc -> mnt/home/etc
	lib -> mnt/home/lib
	mnt/								A place to keep checkouts of various VCS repositories.
		home-private.git				A private repository of sensitive information
		home/.git						**This repository**
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

Traditional dotfiles are replaced by symlinks into `etc/dotfiles` with the leading dot removed. Example:

	~/.bashrc -> mnt/home/etc/dotfiles/bashrc

TODO: Create a script that checks the home directory structure against this policy. (I already have one for managing dotfile symlinks, `bin/update-dotfiles-svn`; update for new git-based structure and improve to manage directories and initial home directory setup as well.

## Heirarchy

I base this organizational scheme loosely on the [Filsystem Heiarchy Standard][fhs]:

	Directory		Purpose

	bin/
					A place for small standalone executables.

					Executables that are part of software packages that I have
					installed on a user-level without the system's package
					management system should live in ~/usr/bin.

	etc/
					Configuration settings.
	etc/dotfiles/
					Configuration "dotfiles", without the dot.

	lib/
					Standalone or in-development support files
	
					I tend to keep ~/lib/python on my $PYTHONPATH, ~/lib/java
					in my $CLASSPATH, and ~/lib/latex2e in my $TEXINPUTS. Then
					I can throw any support files that are universally useful
					into those paths and avoid copying them around from project
					to project.

	mnt/			
					Working-copy checkouts of various VCS repositories

	usr/			
					User-level software package installations; set as --prefix
					when doing a `make install`.

	var/
					Files whose content is expected to continually change
					during normal operation of the system--such as logs, spool
					files, and temporary e-mail files.
	var/desktop/
					Where nautilus keeps items that should be shown "on the desktop"
	var/download/
					Incoming unorganized download bucket for web browser, wget, etc.
	var/local/
					Locally cached copies of stuff otherwise easily available
					with a strong network connection. Assume it's no worse than
					slightly inconveinient to delete this whole folder at any
					time.
	var/log/
					If a user-level script needs a logfile, keep it here.
	var/mail/
					Local mail storage (mutt)
	var/pilot/
					Palm pilot backups, resources
	var/photos/
					Incoming dumping ground for cameras. Photos are organized
					and moved to fileserver.
	var/svn/
					Subversion repositories hosted here, if any.
	var/git/
					Bare git repositories hosted here, if any.
	var/tmp/
					Temporary files to be preserved between reboots.
	var/working/
					Deprecated, use ~/mnt.
	var/www/
					Files to serve from this machine's webserver at http://localhost/~user

According to the [Filesystem Heiarchy Standard][fhs], /tmp is usually cleared every boot, programs should not expect files to persist across invocations.  /var/tmp does not clear at boot time, but may have files removed based on some policy like last-access. These same expectations will apply to ~/tmp and ~/var/tmp.

[fhs]: http://www.pathname.com/fhs/

## Initial setup

TODO: instructions for moving into a new machine.
