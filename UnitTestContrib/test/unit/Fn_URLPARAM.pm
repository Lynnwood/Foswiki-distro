# tests for the correct expansion of URLPARAM
#
# Author: Koen Martens
#
package Fn_URLPARAM;
use FoswikiFnTestCase;
our @ISA = qw( FoswikiFnTestCase );

use strict;

sub new {
    my $self = shift()->SUPER::new( 'URLPARAM', @_ );
    return $self;
}

sub set_up {
    my $this = shift;
    $this->SUPER::set_up(@_);
}

sub test_default {
    my $this = shift;

    my $str;

    # test default parameter

    $str = $this->{test_topicObject}->expandMacros('%URLPARAM{"foo"}%');
    $this->assert_str_equals( '', "$str" );

    $str =
      $this->{test_topicObject}->expandMacros('%URLPARAM{"foo" default="0"}%');
    $this->assert_str_equals( '0', "$str" );

    $str =
      $this->{test_topicObject}->expandMacros('%URLPARAM{"foo" default=""}%');
    $this->assert_str_equals( '', "$str" );

    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar"}%');
    $this->assert_str_equals( 'bar', "$str" );

    $this->{request}->param( -name => 'foo', -value => 'bar' );
    $str =
      $this->{test_topicObject}->expandMacros('%URLPARAM{"foo" default="0"}%');
    $this->assert_str_equals( 'bar', "$str" );

    $this->{request}->param( -name => 'foo', -value => '0' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar"}%');
    $this->assert_str_equals( '0', "$str" );

    $this->{request}->param( -name => 'foo', -value => '' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar"}%');
    $this->assert_str_equals( '', "$str" );

    $this->{request}->param( -name => 'foo', -value => '<evil script>\'\"%' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar"}%');
    $this->assert_str_equals( '&#60;evil script&#62;&#39;\&#34;&#37;', "$str" );
}

sub test_encode {
    my $this = shift;

    my $str;

    $this->{request}->param( -name => 'foo', -value => '<>\'%&?*!"' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" encode="entity"}%');
    $this->assert_str_equals( '&#60;&#62;&#39;&#37;&#38;?&#42;!&#34;', "$str" );

    $this->{request}->param( -name => 'foo', -value => '&?*!" ' );
    $str =
      $this->{test_topicObject}->expandMacros('%URLPARAM{"foo" encode="url"}%');
    $this->assert_str_equals( '%26%3f*!%22%20', "$str" );

    $this->{request}->param( -name => 'foo', -value => '&?*!" ' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" encode="quote"}%');
    $this->assert_str_equals( '&?*!\" ', "$str" );

    $this->{request}->param( -name => 'foo', -value => '<evil script>\'\"%' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar" encode="safe"}%');
    $this->assert_str_equals( '&#60;evil script&#62;&#39;\&#34;&#37;', "$str" );

    $this->{request}->param( -name => 'foo', -value => '<evil script>\'\"%' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar" encode="off"}%');
    $this->assert_str_equals( '<evil script>\'\"%', "$str" );

    $this->{request}->param( -name => 'foo', -value => '<evil script>\'\"%' );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="bar" encode="none"}%');
    $this->assert_str_equals( '<evil script>\'\"%', "$str" );
}

sub test_defaultencode {
    my $this = shift;

    my $str;

    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="&?*!\" " encode="entity"}%');
    $this->assert_str_equals( '&?*!" ', "$str" );

    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="&?*!\" " encode="url"}%');
    $this->assert_str_equals( '&?*!" ', "$str" );

    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"foo" default="&?*!\" " encode="quote"}%');
    $this->assert_str_equals( '&?*!" ', "$str" );
}

sub test_multiple {
    my $this = shift;

    my $str;

    my @multiple = ( 'foo', 'bar', 'baz' );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"multi" multiple="on"}%');
    $this->assert_str_equals( "foo\nbar\nbaz", "$str" );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"multi" multiple="on" separator=","}%');
    $this->assert_str_equals( "foo,bar,baz", "$str" );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"multi" multiple="on" separator=""}%');
    $this->assert_str_equals( "foobarbaz", "$str" );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"multi" multiple="-$item-" separator=" "}%');
    $this->assert_str_equals( "-foo- -bar- -baz-", "$str" );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"multi" multiple="-$item-" separator=""}%');
    $this->assert_str_equals( "-foo--bar--baz-", "$str" );

    $this->{request}
      ->multi_param( -name => 'multi', -value => [ 'foo', 'bar', 'baz' ] );
    $str =
      $this->{test_topicObject}->expandMacros(
        '%URLPARAM{"multi" multiple="-$percnt$item-" encode="none"}%');
    $this->assert_str_equals( "-%foo-\n-%bar-\n-%baz-", "$str" );

    $this->{request}->multi_param(
        -name  => 'multi',
        -value => [ 'f!"�$' . "\n" . '{}[]o', 'b%^&*:@;\'r', 'b()_+-=<>?,./|z' ]
    );
    $str =
      $this->{test_topicObject}->expandMacros(
        '%URLPARAM{"multi" multiple="-$item$quot-" encode="url" separator=","}%'
      );
    $this->assert_str_equals(
"-f!%22%a3%24%0a%7b%7d%5b%5do%22-,-b%25%5e%26*:%40%3b'r%22-,-b%28%29_%2b-%3d%3c%3e%3f%2c./%7cz%22-",
        "$str"
    );
}

sub test_newline {
    my $this = shift;

    my $str;

    $this->{request}->param( -name => 'textarea', -value => "foo\nbar\nbaz\n" );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"textarea" newline="-"}%');
    $this->assert_str_equals( "foo-bar-baz-", "$str" );

    $this->{request}->param( -name => 'textarea', -value => "foo\nbar\nbaz\n" );
    $str =
      $this->{test_topicObject}
      ->expandMacros('%URLPARAM{"textarea" newline=""}%');
    $this->assert_str_equals( "foobarbaz", "$str" );
}

1;
