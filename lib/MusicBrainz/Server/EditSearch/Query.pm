package MusicBrainz::Server::EditSearch::Query;
use Moose;

use MusicBrainz::Server::CGI::Expand qw( expand_hash );
use MooseX::Types::Moose qw( Any ArrayRef Bool Int Maybe Str );
use MooseX::Types::Structured qw( Map Tuple );
use Moose::Util::TypeConstraints qw( enum role_type );
use MusicBrainz::Server::Constants qw( $LIMIT_FOR_EDIT_LISTING );
use MusicBrainz::Server::EditSearch::Predicate::Date;
use MusicBrainz::Server::EditSearch::Predicate::ID;
use MusicBrainz::Server::EditSearch::Predicate::Set;
use MusicBrainz::Server::EditSearch::Predicate::Entity;
use MusicBrainz::Server::EditSearch::Predicate::Editor;
use MusicBrainz::Server::EditSearch::Predicate::EditorFlag;
use MusicBrainz::Server::EditSearch::Predicate::Vote;
use MusicBrainz::Server::EditSearch::Predicate::ReleaseLanguage;
use MusicBrainz::Server::EditSearch::Predicate::ReleaseQuality;
use MusicBrainz::Server::EditSearch::Predicate::ArtistArea;
use MusicBrainz::Server::EditSearch::Predicate::LabelArea;
use MusicBrainz::Server::EditSearch::Predicate::ReleaseCountry;
use MusicBrainz::Server::EditSearch::Predicate::RelationshipType;
use MusicBrainz::Server::Log 'log_warning';
use String::CamelCase qw( camelize );
use Try::Tiny;

my %field_map = (
    id => 'MusicBrainz::Server::EditSearch::Predicate::ID',
    open_time => 'MusicBrainz::Server::EditSearch::Predicate::Date',
    close_time => 'MusicBrainz::Server::EditSearch::Predicate::Date',
    expire_time => 'MusicBrainz::Server::EditSearch::Predicate::Date',
    type => 'MusicBrainz::Server::EditSearch::Predicate::Set',
    status => 'MusicBrainz::Server::EditSearch::Predicate::Set',
    no_votes => 'MusicBrainz::Server::EditSearch::Predicate::ID',
    yes_votes => 'MusicBrainz::Server::EditSearch::Predicate::ID',
    editor => 'MusicBrainz::Server::EditSearch::Predicate::Editor',
    vote => 'MusicBrainz::Server::EditSearch::Predicate::Vote',
    release_language => 'MusicBrainz::Server::EditSearch::Predicate::ReleaseLanguage',
    release_quality => 'MusicBrainz::Server::EditSearch::Predicate::ReleaseQuality',
    artist_area => 'MusicBrainz::Server::EditSearch::Predicate::ArtistArea',
    label_area => 'MusicBrainz::Server::EditSearch::Predicate::LabelArea',
    release_country => 'MusicBrainz::Server::EditSearch::Predicate::ReleaseCountry',
    link_type => 'MusicBrainz::Server::EditSearch::Predicate::RelationshipType',
    editor_flag => 'MusicBrainz::Server::EditSearch::Predicate::EditorFlag',

    map {
        $_ => 'MusicBrainz::Server::EditSearch::Predicate::' . camelize($_)
    } qw( area artist instrument label place recording release release_group series work )
);

has negate => (
    isa => Bool,
    is => 'ro',
    default => 0
);

has combinator => (
    isa => enum([qw( or and )]),
    is => 'ro',
    required => 1,
    default => 'and'
);

has order => (
    isa => enum([qw( asc desc rand )]),
    is => 'ro',
    required => 1,
    default => 'desc'
);

has auto_edit_filter => (
    isa => Maybe[Bool],
    is => 'ro',
    default => undef
);

has where => (
    isa => ArrayRef[ Tuple[ Str, ArrayRef[Any] ] ],
    is => 'bare',
    traits => [ 'Array' ],
    default => sub { [] },
    handles => {
        where => 'elements',
        'add_where' => 'push',
    }
);

has fields => (
    isa => ArrayRef[ role_type('MusicBrainz::Server::EditSearch::Predicate') ],
    is => 'bare',
    required => 1,
    traits => [ 'Array' ],
    handles => {
        fields => 'elements',
    }
);

sub new_from_user_input {
    my ($class, $user_input, $user_id) = @_;
    my $input = expand_hash($user_input);
    my $ae = $input->{auto_edit_filter};
    $ae = undef if $ae =~ /^\s*$/;
    return $class->new(
        exists $input->{negation}   ? (negate => $input->{negation}) : (),
        exists $input->{combinator} ? (combinator => $input->{combinator}) : (),
        exists $input->{order}      ? (order => $input->{order}) : (),
        auto_edit_filter => $ae,
        fields => [
            map {
                $class->_construct_predicate($_, $user_id)
            } grep { defined } @{ $input->{conditions} }
        ]
    );
}

sub _construct_predicate {
    my ($class, $input, $user_id) = @_;
    return try {
        my $predicate_class = $field_map{$input->{field}} or die 'No predicate for field ' . $input->{field};
        $predicate_class->new_from_input(
            $input->{field},
            $input,
            $user_id,
        )
    } catch {
        my $err = $_;
        log_warning { "Unable to construct predicate from input ($err): $_" } $input;
        return ()
    };
}

sub valid {
    my $self = shift;
    my $valid = $self->fields > 0;
    $valid &&= $_->valid for $self->fields;
    return $valid
}

sub as_string {
    my $self = shift;
    $_->combine_with_query($self) for $self->fields;
    my $comb = $self->combinator;
    my $ae_predicate = defined $self->auto_edit_filter ?
        'autoedit = ? AND ' : '';

    my $order = '';
    $order = 'ORDER BY edit.id ' . $self->order
        unless $self->order eq 'rand';

    return 'SELECT edit.* FROM edit ' .
        'WHERE ' . $ae_predicate . ($self->negate ? 'NOT ' : '') . '(' .
            join(" $comb ", map { '(' . $_->[0] . ')' } $self->where) .
        ")
         $order
         LIMIT $LIMIT_FOR_EDIT_LISTING OFFSET ?";
}

sub arguments {
    my $self = shift;
    return (
        $self->auto_edit_filter // (),
        map { @{$_->[1]} } $self->where
    );
}

1;
