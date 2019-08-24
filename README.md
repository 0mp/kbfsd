

# NAME

**kbfsd** - service daemon for the Keybase filesystem (KBFS)

# SYNOPSIS

The required
rc.conf(5)
variables:

*kbfsd\_enable*="`NO`"  
*kbfsd\_user*="*user*"

Optional
rc.conf(5)
variables:

*kbfsd\_keybase\_username*="`${`*kbfsd\_user*`}`"  
*kbfsd\_mountpoint*="*/keybase*"

# DESCRIPTION

**kbfsd**
is an
rc(8)
daemon for the Keybase filesystem (KBFS).
Its aim is to ease the process of using KBFS on
FreeBSD.
It takes care of the configuration the Keybase user would have to do manually
otherwise.

**kbfsd**
does not start automatically even when
*kbfsd\_enable*
is set to
"`YES`"
in
rc.conf(5).
See the
*CAVEATS*
section for more details.

**kbfsd**
has to configure some bits of the system in order to mount KBFS as
*kbfsd\_user*.
*kbfsd\_mountpoint*
is created and
the
sysctl(8)
tunable
*vfs.usermount*
is set to
"1"
so that
*kbfsd\_user*
could mount
*kbfsd\_mountpoint*.
Then
*kbfsd\_user*
is added to the
"operator"
group to be able to use the
*/dev/fuse*
device.
Finally,
**kbfsd**
attempts to spin off the Keybase server and create required socket files.
Note that this step requires
*kbfsd\_user*
to be able to log in as
*kbfsd\_keybase\_username*.
This should be possible once
*kbfsd\_user*
registers a device with
"`keybase device add`".

**kbfsd**
may be controlled with the following
rc.conf(5)
variables:

*kbfsd\_enable*

> (*bool*, default: "`NO`")
> Enable
> **kbfsd**.

*kbfsd\_keybase\_username*

> (*str*, default: *kbfsd\_user*)
> The username used to log into Keybase.

*kbfsd\_mountpoint*

> (*str*, default: "`/keybase`")
> The directory where KBFS should be mounted.

*kbfsd\_user*

> (*str*, no defaults)
> The login name of a user, who should own
> *kbfsd\_mountpoint*.
> It cannot be empty.

# INSTALLATION

The easiest way is to just install the
**kbfsd**
package via
pkg(8)
on
FreeBSD:

	pkg install kbfsd

**kbfsd**
can be installed manually with the following command:

	make all
	make install

# FILES

*/home/*${*kbfsd\_user*}*/.config/keybase/kbfsd.*${*kbfsd\_user*}*.pid*

> PID file.

# EXIT STATUS

The
**kbfsd**
daemon
exits 0 on success, and &gt;0 if an error occurs.

# SEE ALSO

rc.conf(5),
mount(8),
rc(8)

# AUTHORS

The
**kbfsd**
daemon and its manual page were written by
Mateusz Piotrowski &lt;[0mp@FreeBSD.org](mailto:0mp@FreeBSD.org)&gt;.

# CAVEATS

**kbfsd**
is
*not*
started automatically together with other daemons during boot because it uses
the
"`nostart`"
KEYWORD
(see rc(8) for details).
The reason is that in order to reliably mount KBFS the user has to establish
a session with the Keybase server first.
This is done by calling:
"`keybase login` *username*".
Unfortunately, this command happens to block the booting process from time to
time, which is unacceptable.

# BUGS

**kbfsd**
seems to kill
**kbfsfuse**
too rapidly for
**kbfsfuse**
to properly unmount.
As a workaround,
**kbfsd**
calls
umount(8)
on the mount point in the
*poststop*
phase
(see rc.subr(8)).

Currently,
**kbfsd**
uses
*kbfsd\_env*
internally to set the
`HOME`
environmental variable to the home directory of
*kbfsd\_user*.
It is recommended to read the service file before setting
*kbfsd\_env*
in
rc.conf(5).
