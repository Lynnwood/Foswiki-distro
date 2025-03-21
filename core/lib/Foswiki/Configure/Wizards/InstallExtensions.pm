# See bottom of file for license and copyright information
package Foswiki::Configure::Wizards::InstallExtensions;

use strict;
use warnings;

use File::Copy ();
use File::Spec ();
use Cwd        ();

use Assert;

=begin TML

---+ package Foswiki::Configure::Wizards:InstallExtensions

Install and remove extensions

=cut

require Foswiki::Configure::Wizard;
our @ISA = ('Foswiki::Configure::Wizard');

use Foswiki::Configure::Package                    ();
use Foswiki::Configure::Dependency                 ();
use Foswiki::Configure::Wizards::ExploreExtensions ();

our $installRoot;

# (Un)Install the extensions selected by the parameters.

# Common initialisation
sub _getPackage {
    my ( $this, $reporter ) = @_;

    my ( $fwi, $ver, $fwp ) =
      Foswiki::Configure::Dependency::extractModuleVersion( 'Foswiki', 1 );
    ASSERT( $fwi, "No Foswiki.pm" ) if DEBUG;

    my @instRoot = File::Spec->splitdir($fwp);
    pop(@instRoot);

    # SMELL: Force a trailing separator - Linux and Windows are inconsistent
    $installRoot = File::Spec->catfile( @instRoot, 'x' );
    chop $installRoot;

    my $args = $this->param('args');

    # SMELL: This is called with repository as a simple string in
    # the Dependency report, and then again as a hash when running
    # the installer.  The fix is probably elsewhere to use consistent
    # calls,  but hack hack cough... this works.
    my $repo = $args->{repository};
    $repo = $repo->{name} if ( ref($repo) eq 'HASH' );

    die "No repository specified" unless $args->{repository};
    die "No extension specified"  unless $args->{module};

    my $repository;
    foreach my $place (
        Foswiki::Configure::Wizards::ExploreExtensions::findRepositories() )
    {
        if ( $place->{name} eq $repo ) {
            $repository = $place;
            last;
        }
    }
    if ( !$repository ) {
        if ( $args->{USELOCAL} ) {
            $reporter->WARN(
                "Repository not found: $args->{repository}",
                "Will try to use previously downloaded local copy"
            );
        }
        else {
            $reporter->ERROR(
                "Repository $args->{repository} not found\n> Cannot proceed.");
            return undef;
        }
    }
    delete $args->{repository};

    my $pkg = Foswiki::Configure::Package->new(
        root       => $installRoot,
        repository => $repository,
        %$args
    );

    return $pkg;
}

=begin TML

---++ WIZARD depreport

First step in an installation; generate a dependency report.

=cut

sub depreport {
    my ( $this, $reporter ) = @_;

    my $pkg = $this->_getPackage($reporter);
    return unless $pkg;

    $reporter->NOTE( "---++ Dependency report for " . $pkg->module() );
    $pkg->loadInstaller($reporter);
    my ( $installed, $missing ) = $pkg->checkDependencies();
    $reporter->NOTE( "> *INSTALLED*", map { "\t* $_" } @$installed )
      if (@$installed);
    if (@$missing) {
        $reporter->NOTE( "> *MISSING*", map { "\t* $_" } @$missing );
        $reporter->WARN( <<DEPS );
> *Caution:* If you proceed with install, the missing dependencies listed as _Required_
will be automatically installed. Be sure that this is what you want.
DEPS
    }
    else {
        $reporter->NOTE("> All dependencies satisfied");
    }

    $reporter->WARN(
        "\t* Click 'Install' to proceed with the installation.",
        "\t* Click 'Simulate' to get a detailed report on what",
        "\t  will happen during installation."
    );

    $reporter->WARN(
        "\t* Click 'Install without Dependencies' to install",
        "\t  _only_ this extension, ignoring the dependencies."
    ) if (@$missing);

    if ( $this->param('args')->{installable} ) {
        my %data = (
            wizard => 'InstallExtensions',
            method => 'add',
            args   => {
                repository => $pkg->repository(),
                module     => $pkg->module(),
                SIMULATE   => 0,
                NODEPS     => 0,

                # USELOCAL =>
            }
        );
        $reporter->NOTE( $reporter->WIZARD( "Install", \%data ) );

        $data{args}->{SIMULATE} = 1;
        $reporter->NOTE( $reporter->WIZARD( "Simulate", \%data ) );

        if (@$missing) {
            $data{args}->{SIMULATE} = 0;
            $data{args}->{NODEPS}   = 1;
            $reporter->NOTE(
                $reporter->WIZARD( "Install without dependencies", \%data ) );
        }
    }

    $pkg->finish();
    undef $pkg;
}

=begin TML

---++ WIZARD add

Install an extension

=cut

sub add {
    my ( $this, $reporter ) = @_;

    my $pkg = $this->_getPackage($reporter);
    return unless $pkg;

    my $extension = $pkg->module();
    unless ( $pkg->install($reporter) ) {
        $reporter->ERROR( <<OMG );
The Extension may not be usable due to errors. Installation terminated.
OMG
    }

    $pkg->finish();
    undef $pkg;

    return undef;    # return the report
}

=begin TML

---++ WIZARD remove

Uninstall an extension

=cut

sub remove {
    my ( $this, $reporter ) = @_;

    my $pkg = $this->_getPackage($reporter);
    return unless $pkg;

    $pkg->uninstall($reporter);

    $pkg->finish();
    undef $pkg;

    return undef;
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Copyright (C) 2008-2014 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
