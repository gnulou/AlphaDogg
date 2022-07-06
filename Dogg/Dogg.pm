#! /usr/bin/perl
################
use strict;
use warnings;
################
my $author = 'gnulou@scriptdogg.com';
package Dogg
{
  sub new
	{
    my ( $class, $STUFF ) = @_;
    my ($self) = bless $STUFF, $class;
    return $self;
  }

  sub CONFIGURE_HEADER
  {
    my ($self) = @_;
      $self = SELECT_SERVERS($self);
      $self = PAGE_BUTTONS($self);
    return $self;
  }
# ---
sub SELECT_SERVERS
{
  my ($self) = @_;
  my $select_all = 0;
  $self->{DOGG}->{TRANSPORTS} = [];
  my %checkboxes; my $row = 1; my $column = 0;
  my $servs = $self->{DOGG}->{ conf }->{ classes };
  my $fields = $self->{HEADER}->{LABEL}->Frame(-bg=>'#565656')->pack();
  foreach my $field (@{$servs})
  {
    $checkboxes
    { fields}{$field} = $fields->Checkbutton
      ( -text => "$field", -font => "arial 11 bold",
        -foreground=>"#FFDE5B", -bg=>'#1A1A1A',
        -command => sub { push @{$self->{DOGG}->{TRANSPORTS}},$field; }
      )->grid
        ( -row => $row, -column => $column++, -ipadx => '5', -ipady => '5',
          -pady => '5', -padx => '5');
    if($column > 2) { $row++; $column = 0; }
  }

  $checkboxes{all} = $fields ->Checkbutton
    ( -text => "Select All", -font => "arial 11 bold",
      -foreground=>"#565656", -bg=>'#FFDE5B',
      -command => sub
        {
          for ( values %{$checkboxes{fields}} )
            { $checkboxes{all}->{'Value'} ? $_->select : $_->deselect; }
        }
    )->grid
      ( -ipadx => '5', -ipady => '5', -pady => '5',
        -padx => '5', -row => $row, -column => $column );
  #$self->{DOGG}->{TRANSPORTS} = @transports;
  $self->{HEADER}->{ELEMENT} = $fields;
  return $self;
}

sub PAGE_BUTTONS
{
  my ($self) = @_;
  my $clss = $self->{ DOGG }->{ conf }->{ roles };

  $self->{HEADER}->{ELEMENT} =
    $self->{HEADER}->{FRAME}->LabFrame
      ( -bg=>'#565656', -fg=>'#FFDE5B', -label=>'Action Classes'
      )->pack( -fill=>'x' );

  foreach my $but (@{$clss})
  {
    $self->{HEADER}->{ELEMENT}->Button
    ( -font => "arial 16 bold", -foreground=>'#565656',
      -bg=>"#FFDE5B", -text => $but,
      -command => sub
        {
          $self->{PAGE}->{name} = $but;
          $self = MAIN_CONTENT($self);
        }
      )->pack( -side =>'top', -fill =>'x', -expand =>1 );
  }
  return $self;
}

sub CONFIGURE_BODY
{
  my ($self) = @_;
  return MAIN_CONTENT($self);
}

sub MAIN_CONTENT
{
  my ($self) = @_;
  unless($self->{PAGE})
    { $self = DEFAULT_PAGE($self); }
  else
  {
    un_pack($self->{BODY}->{FRAME});
    $self = SET_MAIN_CONTENT($self);
  }
  return $self;
}

  sub GET_MAIN_CONTENT
  {
    my ($self) = @_;
    return $self->{ DOGG }->{ wdgt }->{$self->{ PAGE }->{ name }};
  }

sub SET_MAIN_CONTENT
{
  my ($self) = @_;
    $self->{PAGE}->{content} = GET_MAIN_CONTENT($self);
    $self->{PAGE}->{action} = SELECT_SCRIPT($self);
  return $self;
}

sub SELECT_SCRIPT
{
  my ($self) = @_;
  my $scrpts = [];
  foreach my $key (keys %{$self->{PAGE}->{content}})
    { push @{$scrpts}, $key; }

  $self->{BODY}->{ELEMENTS}->{SCRIPTS} =
    $self->{BODY}->{FRAME}->LabFrame
      ( -bg=>'#565656',
        -foreground=>"#FFDE5B",
        -label => "Select an Action",
      )->pack( -side => "top" , -fill => "x" );

  my $row = 1;
  my $column = 0;
  foreach my $value (@{$scrpts})
  {
    $self->{BODY}->{ELEMENTS}->{SCRIPTS}->Radiobutton
    ( -font => "arial 12 bold", -foreground=>"#FFDE5B",
      -bg=>'#565656', -text => ucfirst("$value") , -value => $value,
      -command => sub
        {
          $self->{DOGG}->{action} = $value;
          $self = ACTION_PAGE($self);
        }
    )->grid
      ( -row => $row, -column => $column++,
        -ipadx => '5', -ipady => '5',
        -pady => '5', -padx => '5');

    if($column > 4)
      { $row++; $column = 0; }
  }
  return $self;
}

  sub ACTION_PAGE
  {
    my ($self) = @_;
    if($self->{BODY}->{ELEMENTS}->{ENTRIES})
    {
      un_pack($self->{BODY}->{FRAME});
      $self->{PAGE}->{action} = SELECT_SCRIPT($self);
    }

    $self->{BODY}->{ELEMENTS}->{ACTION} =
      $self->{BODY}->{FRAME}->LabFrame
        ( -bg=>'#565656', -foreground=>"#FFDE5B",
          -label => $self->{DOGG}->{action}, -font => "arial 18 bold"
        )->pack( -side => "top", -fill => "x");

      $self->{BODY}->{ELEMENTS}->{ENTRIES} =
        $self->{BODY}->{ELEMENTS}->{ACTION}->Frame
          ( -bg=>'#565656' )->pack( -anchor=>'nw', -pady => 15, -padx => 15 );
      print $self->{DOGG}->{action}." --wurps.\n";
      while (my ($keys, $values) =
        each @{$self->{PAGE}->{content}->{$self->{DOGG}->{action}}->{wdgt}})
        {
          while (my ($key, $value) =  each %{$values})
          {
            print "$key --\n";

              print "$value --\n";
            my @p = %{$value->{PACK}};
            my @t = %{$value->{TRAIT}};
            $self->{BODY}->{ELEMENTS}->{ENTRIES}->$key(@t)->pack(@p);
          }
        }

      $self->{BODY}->{ELEMENTS}->{BUTTONS} =
        $self->{BODY}->{ELEMENTS}->{ACTION}->Frame
          ( -bg=>'#565656')->pack( -side=>'top', -fill=>'x' );

      $self->{BODY}->{ELEMENTS}->{BUTTONS}->Button
      ( -foreground=>'#565656', -bg=>"#FFDE5B", -text => 'Run Action',
        -command =>
          sub
          {
            my $s = $self->{PAGE}->{content}->{$self->{DOGG}->{action}}->{scrpt};
            print $self->{DOGG}->{action}." ".$s." ".@{$self->{DOGG}->{TRANSPORTS}};
            #system("bash scripts/Dogg 'main_".lc($lfdummy)."' '".$alias."' '".$scrpt."'");
          }
      )->pack( -side=>'right' );

      $self->{BODY}->{ELEMENTS}->{BUTTONS}->Button
        ( -foreground=>'#565656', -bg=>"#FFDE5B", -text => 'Cancel',
        	-command =>
        		sub
        		{
        		#	system("bash scripts/Dogg 'main_".lc($lfdummy)."' '".$alias."' '".$scrpt."'");
        		}
        )->pack( -side => 'right', -padx => 10 );
    return $self;
  }

  sub DEFAULT_PAGE
  {
    my ($self) = @_;
    $self->{BODY}->{ELEMENTS}->{ACTION} =
      $self->{BODY}->{FRAME}->LabFrame
        ( -bg=>'#565656', -foreground=>"#FFDE5B",
          -label =>"Action Entries", -font => "arial 18 bold"
        )->pack( -side => "top", -fill => "x" );

    $self->{BODY}->{ELEMENTS}->{ENTRIES} =
      $self->{BODY}->{ELEMENTS}->{ACTION}->Frame
        ( -bg=>'#565656' )->pack( -anchor=>'nw', -ipady=>10 );

    $self->{BODY}->{ELEMENTS}->{ENTRIES}->Label
      ( -bg=>'#565656', -foreground=>"#FFDE5B",
        -text =>"Please Select an Action from the list above.",
        -font => "arial 14 normal"
      )->pack( -side => "top", -anchor => "w" );

    return $self;
  }

  sub un_pack
  {
    my @w = $_[0]->packSlaves;
    foreach (@w)
      { print $_->packForget; }
  }
  sub re_pack
  {
    my @w = $_[0]->packSlaves;
    foreach (@w)
      { print $_->packForget; $_->pack; }
  }
  sub _pack_
  {
    my @w = $_[0]->packSlaves;
    foreach (@w)
      { $_->pack; }
  }
# ---
}1;
=pod
#-variable => \$self->{DOGG}->{SCRIPT},
#[ \&SET_MAIN_CONTENT, $self, $but ]
#[ \&SET_MAIN_CONTENT, $self, $value],

=cut
