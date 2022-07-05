#! /usr/bin/perl
################
use strict;
use warnings;
################
my $author = 'gnulou@scriptdogg.com';
package AlphaDogg
{
  use YAML qw(LoadFile DumpFile);
	sub new
	{
		my ($class, $DOGGFILE) = @_;
		my ($self) = bless
      { doggfile => $DOGGFILE, dogg => LoadFile( $DOGGFILE ) } , $class;
		return $self->{dogg};
	}
	sub DESTROY
	{
		local($., $@, $!, $^E, $?);
		my $self = shift;
		return if ${^GLOBAL_PHASE} eq 'DESTRUCT';
		if ($self->{dogg})
		  { DumpFile( $self->{doggfile}, $self->{dogg} ); }
	}
}1;
=pod
#$self->{conf}->close() if $self->{conf};
#$self->{confile}->close() if $self->{confile};
=cut
