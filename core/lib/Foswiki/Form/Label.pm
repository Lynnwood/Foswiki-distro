# See bottom of file for license and copyright information
package Foswiki::Form::Label;

use strict;
use warnings;

use Foswiki::Form::FieldDefinition ();
our @ISA = ('Foswiki::Form::FieldDefinition');

BEGIN {
    if ( $Foswiki::cfg{UseLocale} ) {
        require locale;
        import locale();
    }
}

sub isEditable {
    return 0;
}

sub renderForEdit {
    my ( $this, $topicObject, $value ) = @_;

    # Changing labels through the URL is a feature for Foswiki applications,
    # even though it's not accessible for standard edits. Some contribs
    # may want to override this to make labels editable.
    my $renderedValue = $topicObject->expandMacros($value);
    return (
        '',
        CGI::hidden(
            -name  => $this->{name},
            -value => $value
          )
          . CGI::div( { -class => 'foswikiFormLabel', }, $renderedValue )
    );
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2010 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

Additional copyrights apply to some or all of the code in this
file as follows:

Copyright (C) 2001-2007 TWiki Contributors. All Rights Reserved.
TWiki Contributors are listed in the AUTHORS file in the root
of this distribution. NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
