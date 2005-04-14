#!/home/httpd/musicbrainz/mb_server/cgi-bin/perl -w
# vi: set ts=4 sw=4 :
#____________________________________________________________________________
#
#   MusicBrainz -- the open internet music database
#
#   Copyright (C) 2000 Robert Kaye
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#   $Id$
#____________________________________________________________________________

use strict;

package MusicBrainz::Server::Moderation::MOD_ADD_ARTIST;

use ModDefs;
use base 'Moderation';

sub Name { "Add Artist" }
(__PACKAGE__)->RegisterHandler;

sub PreInsert
{
	my ($self, %opts) = @_;

	my $name = $opts{'name'};
	my $sortname = $opts{'sortname'};
	my $type = $opts{'artist_type'};
	my $resolution = $opts{'artist_resolution'};
	my $begindate = $opts{'artist_begindate'};
	my $enddate = $opts{'artist_enddate'};

	MusicBrainz::TrimInPlace($name) if defined $name;
	$name =~ /\S/ or die $self->SetError('Artist name not set');;
	
	MusicBrainz::TrimInPlace($sortname) if defined $sortname;
	$sortname = $name if not defined $sortname or $sortname eq "";

	# We allow a type of 0. It is mapped to NULL in the DB.
	die $self->SetError('Artist type invalid')
		unless Artist::IsValidType($type) or not defined $type;

	MusicBrainz::TrimInPlace($resolution) if defined $resolution;

	# undefined $begindate means: no date given
	my $begindate_str;
	if ( defined $begindate and $begindate->[0] ne '')
	{
		die 'Invalid begin date' unless MusicBrainz::IsValidDate(@$begindate);
		$begindate_str = MusicBrainz::MakeDBDateStr(@$begindate);
	}

	my $enddate_str;
	if ( defined $enddate and $enddate->[0] ne '')
	{
		die 'Invalid end date' unless MusicBrainz::IsValidDate(@$enddate);
		$enddate_str = MusicBrainz::MakeDBDateStr(@$enddate);
	}
	
	# Prepare the data that Insert needs.
	#
	my %info = (
		artist		=> $name,
		sortname	=> $sortname,
		artist_only	=> 1,
	);
	
	$info{'artist_type'} = $type if $type;
	$info{'artist_resolution'} = $resolution if defined $resolution;
	$info{'artist_begindate'} = $begindate_str if defined $begindate_str;
	$info{'artist_enddate'} = $enddate_str if defined $enddate_str;

	require Insert;
	my $in = Insert->new($self->{DBH});
	my $ans = $in->Insert(\%info);

	# TODO I'm not sure this path is ever used - I think $ans is always true.
	defined($ans)
		or ($self->SetError($in->GetError), die $self);

	# The artist has been inserted. Now set up the moderation record
	# to undo it if the vote fails.

	my %new = (
		ArtistName => $name,
		SortName => $sortname,
	);

	$new{'Type'} = $info{'artist_type'}
		if exists $info{'artist_type'};
	$new{'Resolution'} = $info{'artist_resolution'}
		if exists $info{'artist_resolution'};
	$new{'BeginDate'} = $info{'artist_begindate'}
		if exists $info{'artist_begindate'};
	$new{'EndDate'} = $info{'artist_enddate'}
		if exists $info{'artist_enddate'};
	$new{'ArtistId'} = $info{'artist_insertid'};

	$self->SetTable('artist');
	$self->SetColumn('name');
	$self->SetArtist($info{'artist_insertid'});
	$self->SetRowId($info{'artist_insertid'});
	$self->SetNew($self->ConvertHashToNew(\%new));
}

sub PostLoad
{
	my $self = shift;
	$self->{'new_unpacked'} = $self->ConvertNewToHash($self->GetNew)
		or die;
}

sub ApprovedAction
{
	&ModDefs::STATUS_APPLIED;
}

sub DeniedAction
{
  	my $self = shift;
	my $newval = $self->{'new_unpacked'};

	# Do nothing - the cleanup script will handle this
}

1;
# eof MOD_ADD_ARTIST.pm
