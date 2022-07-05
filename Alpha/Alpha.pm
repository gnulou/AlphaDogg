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
		my $self = bless
		{
			BODY	  =>	$STUFF->{$STUFF->{name}}->{wdgt}->{BODY},
			DOGG    => 	$STUFF,
			HEADER 	=> 	$STUFF->{$STUFF->{name}}->{wdgt}->{HEADER},
			MAIN 	  =>	MainWindow->new,
			WINDOW 	=> 	$STUFF->{$STUFF->{name}}->{wdgt}->{WINDOW},
			WRAPPER => 	$STUFF->{$STUFF->{name}}->{wdgt}->{WRAPPER}
		}, $class;
		return $self;
	}
	sub LOAD_DOGG
	{
		my ($self) = @_;
		  $self = WINDOW_MAIN($self);
		  $self = WINDOW_HEADER($self);
      $self = WINDOW_BODY($self);

		if($self->{DOGG}->{name} eq 'scriptDogg')
		{
			#use lib 'ScriptDogg/';
			#use ScriptDogg;
			#$self = ScriptDogg->new($self);
			#$self->CONFIGURE_HEADER;
			#$self->CONFIGURE_BODY;
		}
		else
      { print "Dogg name ".$self->{DOGG}->{name}."is not supported.\n"; }
    return $self;
	}
	sub WINDOW_MAIN
	{
		my ($STUFF) = @_;
		$STUFF = &CONFIGURE_MAIN( $STUFF );
		$STUFF->{WRAPPER} = &WIDGETS
      ( $STUFF->{MAIN}, $STUFF->{WRAPPER} );
		return $STUFF;
	}
	sub WINDOW_HEADER
	{
		my ($STUFF) = @_;
		$STUFF->{HEADER}->{FRAME} = &WIDGETS
      ( $STUFF->{WRAPPER}, $STUFF->{HEADER}->{FRAME} );

		$STUFF->{HEADER}->{LABEL} = &WIDGETS
      ( $STUFF->{HEADER}->{FRAME}, $STUFF->{HEADER}->{LABEL} );
		return $STUFF;
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
		{
			unless(ref $key)
			{
				$widget = $key;
				while(my ($keys, $values) = each %{$value})
				{
					if($keys eq 'TRAIT')
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
