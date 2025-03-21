# ---+ Extensions
# ---++ RCSStoreContrib
# **ENHANCE {Store}{Implementation}**
# <dl><dt>RcsWrap</dt><dd>
# (installed by the RCSStoreContrib) uses the 'rcs' revision control
# system to store the history of topics and attachments. It calls the rcs
# executables directly, and requires rcs to be installed on the server.
# It's a good choice for sites that have a pre-existing Foswiki (or TWiki)
# where compatibility with existing data and scripts is paramount.
# Performance is generally good on most platforms except Windows.</dd></dl>
# **ENHANCE {Store}{Implementation}**
# <dl><dt>RcsLite</dt><dd>
# uses a pure-perl simplified implementation of the 'rcs' revision
# control system.
# It's a good choice for sites that have a pre-existing Foswiki (or TWiki)
# where compatibility with existing data and scripts is paramount, but 
# RcsWrap cannot be used; for example, on  hosted platform where 'rcs'
# cannot be installed, or on Windows where RcsWrap performance is poor.
# </dd></dl>
# **BOOLEAN**
# Some file-based Store implementations (RcsWrap and RcsLite) store
# attachment meta-data separately from the actual attachments.
# This means that it is possible to have a file in an attachment directory
# that is not seen as an attachment by Foswiki. Sometimes it is desirable to
# be able to simply copy files into a directory and have them appear as
# attachments, and that's what this feature allows you to do.
# Considered experimental.
$Foswiki::cfg{RCS}{AutoAttachPubFiles} = $FALSE;

# **STRING 20**
# Specifies the extension to use on RCS files. Set to -x,v on Windows, leave
# blank on other platforms.
$Foswiki::cfg{RCS}{ExtOption} = '';

# **BOOLEAN EXPERT**
# Switches on/off the generation of tabular format .changes files that can
# be read by Foswiki 1.1. Required for sites where the same data is being
# used by both versions.
$Foswiki::cfg{RCS}{TabularChangeFormat} = 0;

# **REGEX**
# Perl regular expression matching suffixes valid on plain text files
# Defines which attachments will be treated as ASCII in RCS. This is a
# filter <b>in</b>, so any filenames that match this expression will
# be treated as ASCII.
$Foswiki::cfg{RCS}{asciiFileSuffixes} = qr/\.(txt|html|xml|pl)$/;

# **BOOLEAN DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# Set this if your RCS cannot check out using the -p option.
# May be needed in some windows installations (not required for cygwin)
$Foswiki::cfg{RCS}{coMustCopy} = $FALSE;

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap initialise a file as binary.
# %FILENAME|F% will be expanded to the filename.
$Foswiki::cfg{RCS}{initBinaryCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -i -t-none -kb %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap initialise a topic file.
$Foswiki::cfg{RCS}{initTextCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -i -t-none -ko %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap uses this on Windows to create temporary binary files during upload.
$Foswiki::cfg{RCS}{tmpBinaryCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -kb %FILENAME|F%';

# **COMMAND EXPERT**
# RcsWrap check-in.
# %USERNAME|S% will be expanded to the username.
# %COMMENT|U% will be expanded to the comment.
$Foswiki::cfg{RCS}{ciCmd} =
'/usr/bin/ci $Foswiki::cfg{RCS}{ExtOption} -m%COMMENT|U% -t-none -w%USERNAME|S% -u %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap check in, forcing the date.
# %DATE|D% will be expanded to the date.
$Foswiki::cfg{RCS}{ciDateCmd} =
'/usr/bin/ci $Foswiki::cfg{RCS}{ExtOption} -m%COMMENT|U% -t-none -d%DATE|D% -u -w%USERNAME|S% %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap check out.
# %REVISION|N% will be expanded to the revision number
$Foswiki::cfg{RCS}{coCmd} =
  '/usr/bin/co $Foswiki::cfg{RCS}{ExtOption} -p%REVISION|N% -ko %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap file history.
$Foswiki::cfg{RCS}{histCmd} =
  '/usr/bin/rlog $Foswiki::cfg{RCS}{ExtOption} -h %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap revision info about the file.
$Foswiki::cfg{RCS}{infoCmd} =
  '/usr/bin/rlog $Foswiki::cfg{RCS}{ExtOption} -r%REVISION|N% %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap revision info about the revision that existed at a given date.
# %REVISIONn|N% will be expanded to the revision number.
# %CONTEXT|N% will be expanded to the number of lines of context.
$Foswiki::cfg{RCS}{rlogDateCmd} =
  '/usr/bin/rlog $Foswiki::cfg{RCS}{ExtOption} -d%DATE|D% %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap differences between two revisions.
$Foswiki::cfg{RCS}{diffCmd} =
'/usr/bin/rcsdiff $Foswiki::cfg{RCS}{ExtOption} -q -w -B -r%REVISION1|N% -r%REVISION2|N% -ko --unified=%CONTEXT|N% %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap lock a file.
$Foswiki::cfg{RCS}{lockCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -l %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap unlock a file.
$Foswiki::cfg{RCS}{unlockCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -u %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap break a file lock.
$Foswiki::cfg{RCS}{breaklockCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -u -M %FILENAME|F%';

# **COMMAND DISPLAY_IF {Store}{Implementation}=='Foswiki::Store::RcsWrap'**
# RcsWrap delete a specific revision.
$Foswiki::cfg{RCS}{delRevCmd} =
  '/usr/bin/rcs $Foswiki::cfg{RCS}{ExtOption} -o%REVISION|N% %FILENAME|F%';
1;
