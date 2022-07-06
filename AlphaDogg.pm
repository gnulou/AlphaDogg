#! /usr/bin/perl
################
use strict;
use warnings;
################
my $author = 'gnulou@scriptdogg.com';
package AlphaDogg
{
  use Tk;
  use Tk::BrowseEntry;
  use Tk::LabFrame;
  use YAML qw(LoadFile DumpFile);
  use lib 'Alpha/';
  use lib 'Dogg/';
  sub new
	{
		my ( $class, $WdPath ) = @_;
    my $aDoggMeta = "META.yaml";
    my ($self) = bless
      { id => time, name	=> $class,
        path => $WdPath, file => $WdPath.$aDoggMeta,
        meta => LoadFile( $WdPath.$aDoggMeta )
      } , $class;
		return $self;
	}

	sub DESTROY
	{
		local($., $@, $!, $^E, $?);
		my $self = shift;
		return if ${^GLOBAL_PHASE} eq 'DESTRUCT';
		if ($self->{ meta })
		  { DumpFile( $self->{ file }, $self->{meta} ); }
    #if ( $self->{ wndw } )
    #  { DumpFile( $self->{ path }.$self->{ meta }->{ wndwfile }, $self->{ wndw } ); }
    #if ( $self->{ wdgt } )
    #    { DumpFile( $self->{ path }.$self->{ meta }->{ wdgtfile }, $self->{ wdgt } ); }
    #if ( $self->{ conf } )
    #    { DumpFile( $self->{ path }.$self->{ meta }->{ confile }, $self->{ conf } ); }
	}

  sub LOAD_MAIN_WNDW_FROM_FILE
  {
    my ($self) = @_;
      $self->{wndw} = LoadFile( $self->{ path }.$self->{ meta }->{ wndwfile } );
    return $self;
  }

  sub LOAD_MAIN_WDGT_FROM_FILE
  {
    my ($self) = @_;
      $self->{ DOGG }->{ wdgt } = LoadFile( $self->{ path }.$self->{ meta }->{ wdgtfile } );
    return $self;
  }

  sub LOAD_MAIN_CONF_FROM_FILE
  {
    my ($self) = @_;
      $self->{ DOGG }->{ conf } = LoadFile( $self->{ path }.$self->{ meta }->{ confile } );
    return $self;
  }

  sub LOAD_MAIN_META_FILES
  {
    my ( $self ) = @_;
      $self->LOAD_MAIN_WNDW_FROM_FILE;
      $self->LOAD_MAIN_WDGT_FROM_FILE;
      $self->LOAD_MAIN_CONF_FROM_FILE;
    return $self;
  }

  sub MAIN_WNDW
  {
    my ( $self ) = @_;
      $self->LOAD_MAIN_WNDW_FROM_FILE;
    use Alpha;
      $self->{ mWNDW } = Alpha->new( $self->{ wndw } );
      $self->{ mWNDW }->{ MAIN } =	MainWindow->new;
      $self->{ mWNDW }->WINDOW_MAIN;
      $self->{ mWNDW }->WINDOW_HEADER;
      $self->{ mWNDW }->WINDOW_BODY;
      $self->LOAD_MAIN_WDGT_FROM_FILE;
      $self->LOAD_MAIN_CONF_FROM_FILE;
      $self->{ mWNDW }->{ DOGG } = $self->{ DOGG };
    use Dogg;
      $self->{ mWDGT } = Dogg->new( $self->{ mWNDW } );
      $self->{ mWDGT }->CONFIGURE_HEADER;
      $self->{ mWDGT }->CONFIGURE_BODY;
      $self->MAIN_LOOP;
  }

  sub MAIN_LOOP { MainLoop; }

}1;
=pod
#$self->{conf}->close() if $self->{conf};
#$self->{confile}->close() if $self->{confile};
=cut
