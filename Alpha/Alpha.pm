#! /usr/bin/perl
################
use strict;
use warnings;
################
my $author = 'gnulou@scriptdogg.com';
package Alpha
{
  sub new
	{
		my ($class, $STUFF) = @_;
		my $self = bless $STUFF, $class;
		return $self;
	}

	sub WINDOW_MAIN
	{
		my ( $self ) = @_;
		$self = &CONFIGURE_MAIN( $self );
		$self->{ WRAPPER } = &WIDGETS
      ( $self->{ MAIN }, $self->{ WRAPPER } );
    return $self;
	}
	sub WINDOW_HEADER
	{
		my ( $self ) = @_;
		$self->{ HEADER }->{ FRAME } = &WIDGETS
      ( $self->{ WRAPPER }, $self->{ HEADER }->{ FRAME } );

		$self->{ HEADER }->{ LABEL } = &WIDGETS
      ( $self->{ HEADER }->{ FRAME }, $self->{ HEADER }->{ LABEL } );
		return $self;
	}
	sub WINDOW_BODY
	{
		my ($STUFF) = @_;
		$STUFF->{BODY}->{FRAME} = &WIDGETS
      ( $STUFF->{WRAPPER}, $STUFF->{BODY}->{FRAME} );
		return $STUFF;
	}

	sub CONFIGURE_MAIN
	{
		my ($STUFF) = @_;
		while(my ($key, $value) = each %{$STUFF->{WINDOW}})
		  { $STUFF->{MAIN}->$key("$value"); }
		return $STUFF;
	}

	sub trait_CONFIGURE
	{
		my $options = shift;
		my @opt;
		while( my ($key, $value) = each %{$options})
      { push @opt, $key; push @opt, $value; }
		return @opt;
	}

	sub WIDGETS
	{ # WINDOW
		my $window 	= shift;
		my ($self) 	= @_;
		my ($widget, $geom, $new_window, @traits, @geo);
		while(my ($key, $value) = each %{$self})
		{ unless(ref $key)
			{ $widget = $key;
				while(my ($keys, $values) = each %{$value})
				{ if($keys eq 'TRAIT')
            { @traits = &trait_CONFIGURE($values); }
					elsif($keys eq 'PACK')
					  { $geom = $keys; @geo = &trait_CONFIGURE($values); }
					elsif($keys eq 'GRID')
            { $geom = $keys; @geo = &trait_CONFIGURE($values); }
					else
            { print "BAD-".$values."--".$key."\n"; }
				}
			}
		}
		if($geom eq 'GRID')
		  { $new_window = $window->$widget(@traits)->grid(@geo); }
		else
		  { $new_window = $window->$widget(@traits)->pack(@geo); }
		return $new_window;
	}

  sub TO_JSON
    { return { %{ shift() } }; }
}1;
=pod

=cut
