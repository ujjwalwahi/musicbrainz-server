package MusicBrainz::Server::Edit::Relationship::Create;
use Moose;

use List::AllUtils qw( any );
use MusicBrainz::Server::Edit::Types qw( LinkAttributesArray PartialDateHash Nullable NullableOnPreview );
use MusicBrainz::Server::Translation qw( N_l );

extends 'MusicBrainz::Server::Edit::Generic::Create';
with 'MusicBrainz::Server::Edit::Relationship';
with 'MusicBrainz::Server::Edit::Relationship::RelatedEntities';
with 'MusicBrainz::Server::Edit::Role::Preview';

use MooseX::Types::Moose qw( ArrayRef Bool Int Str );
use MooseX::Types::Structured qw( Dict Optional );
use MusicBrainz::Server::Constants qw( $EDIT_RELATIONSHIP_CREATE );
use MusicBrainz::Server::Data::Utils qw( type_to_model );
use MusicBrainz::Server::Edit::Utils qw( normalize_date_period );

use aliased 'MusicBrainz::Server::Entity::Link';
use aliased 'MusicBrainz::Server::Entity::LinkType';
use aliased 'MusicBrainz::Server::Entity::Relationship';
use aliased 'MusicBrainz::Server::Entity::PartialDate';

sub edit_type { $EDIT_RELATIONSHIP_CREATE }
sub edit_name { N_l('Add relationship') }
sub _create_model { 'Relationship' }

has '+data' => (
    isa => Dict[
        entity0      => Dict[
            id   => NullableOnPreview[Int],
            name => Str
        ],
        entity1      => Dict[
            id   => NullableOnPreview[Int],
            name => Str
        ],
        link_type    => Dict[
            id => Int,
            name => Str,
            link_phrase => Str,
            reverse_link_phrase => Str,
            long_link_phrase => Str
        ],
        attributes   => Nullable[LinkAttributesArray],
        begin_date   => Nullable[PartialDateHash],
        end_date     => Nullable[PartialDateHash],
        type0        => Str,
        type1        => Str,
        ended        => Optional[Bool],
        link_order   => Optional[Int],
        edit_version => Optional[Int],
    ]
);

sub initialize
{
    my ($self, %opts) = @_;
    my $e0 = delete $opts{entity0} or die "No entity0";
    my $e1 = delete $opts{entity1} or die "No entity1";
    my $lt = delete $opts{link_type} or die "No link type";

    my $link_type_id = $lt->id;
    die "Link type $link_type_id is only used for grouping" unless $lt->description;

    if (my $attributes = $opts{attributes}) {
        if (@$attributes) {
            $self->check_attributes($lt, $attributes);
        } else {
            delete $opts{attributes};
        }
    }

    die "Entities in a relationship cannot be the same"
        if $lt->entity0_type eq $lt->entity1_type && $e0->id == $e1->id;

    $opts{entity0} = {
        id => $e0->id,
        name => $e0->name,
    };

    $opts{entity1} = {
        id => $e1->id,
        name => $e1->name,
    };

    $opts{link_type} = {
        id => $lt->id,
        name => $lt->name,
        link_phrase => $lt->link_phrase,
        reverse_link_phrase => $lt->reverse_link_phrase,
        long_link_phrase => $lt->long_link_phrase
    };

    $opts{type0} = $lt->entity0_type;
    $opts{type1} = $lt->entity1_type;

    delete $opts{link_order} unless $opts{link_order} && $lt->orderable_direction;

    normalize_date_period(\%opts);
    delete $opts{begin_date} unless any { defined($_) } values %{ $opts{begin_date} };
    delete $opts{end_date} unless any { defined($_) } values %{ $opts{end_date} };

    MusicBrainz::Server::Edit::Exceptions::NoChanges->throw
        if $self->c->model('Relationship')->exists(
            $lt->entity0_type,
            $lt->entity1_type, {
            link_type_id => $lt->id,
            begin_date   => $opts{begin_date},
            end_date     => $opts{end_date},
            ended        => $opts{ended},
            attributes   => $opts{attributes},
            entity0_id   => $e0->id,
            entity1_id   => $e1->id,
        });

    $self->data({ %opts, edit_version => 2 });
}

sub foreign_keys
{
    my ($self) = @_;

    my %load = (
        LinkType            => [ $self->data->{link_type}{id} ],
        LinkAttributeType   => { map { $_->{type}{id} => ['LinkAttributeType'] } @{ $self->data->{attributes} // [] } },
    );

    my $type0 = $self->data->{type0};
    my $type1 = $self->data->{type1};

    my $entity0_id = $self->data->{entity0}{id};
    my $entity1_id = $self->data->{entity1}{id};

    $load{ type_to_model($type0) } = { $entity0_id => ['ArtistCredit'] } if $entity0_id;

    # Type 1 my be equal to type 0, so we need to be careful
    $load{ type_to_model($type1) } ||= {};
    $load{ type_to_model($type1) }{$entity1_id} = [ 'ArtistCredit' ] if $entity1_id;

    return \%load;
}

sub build_display_data
{
    my ($self, $loaded) = @_;
    my $model0 = type_to_model($self->data->{type0});
    my $model1 = type_to_model($self->data->{type1});

    return {
        relationship => Relationship->new(
            link => Link->new(
                type       => $loaded->{LinkType}{ $self->data->{link_type}{id} }
                    || LinkType->new($self->data->{link_type}),
                begin_date => PartialDate->new_from_row( $self->data->{begin_date} ),
                end_date   => PartialDate->new_from_row( $self->data->{end_date} ),
                ended      => $self->data->{ended},
                attributes => [
                    map {
                        my $attr = $loaded->{LinkAttributeType}{ $_->{type}{id} };
                        if ($attr) {
                            MusicBrainz::Server::Entity::LinkAttribute->new(
                                type => $attr,
                                credited_as => $_->{credited_as},
                                text_value => $_->{text_value},
                            )
                        }
                        else {
                            ()
                        }
                    } @{ $self->data->{attributes} }
                ],
            ),
            entity0 => $loaded->{$model0}{ $self->data->{entity0}{id} } ||
                $self->c->model($model0)->_entity_class->new(
                    name => $self->data->{entity0}{name}
                ),
            entity1 => $loaded->{$model1}{ $self->data->{entity1}{id} } ||
                $self->c->model($model1)->_entity_class->new(
                    name => $self->data->{entity1}{name}
                ),
            link_order => $self->data->{link_order} // 0,
        ),
        unknown_attributes => scalar(
            grep { !exists $loaded->{LinkAttributeType}{$_->{type}{id}} }
                @{ $self->data->{attributes} // [] }
        )
    }
}

sub directly_related_entities
{
    my ($self) = @_;

    my $result;
    if ($self->data->{type0} eq $self->data->{type1}) {
        $result = {
            $self->data->{type0} => [ $self->data->{entity0}{id},
                                      $self->data->{entity1}{id} ]
        };
    }
    else {
        $result = {
            $self->data->{type0} => [ $self->data->{entity0}{id} ],
            $self->data->{type1} => [ $self->data->{entity1}{id} ]
        };
    }

    return $result;
}

sub adjust_edit_pending
{
    my ($self, $adjust) = @_;

    $self->c->model('Relationship')->adjust_edit_pending(
        $self->data->{type0}, $self->data->{type1},
        $adjust, $self->entity_id);
}

sub insert
{
    my ($self) = @_;

    my $link_type_id = $self->data->{link_type}{id};
    my $link_type = $self->c->model('LinkType')->get_by_id($link_type_id);
    die "Link type $link_type_id is deprecated" if $link_type->is_deprecated;

    my $relationship = $self->c->model('Relationship')->insert(
        $self->data->{type0},
        $self->data->{type1}, {
            entity0_id   => $self->data->{entity0}{id},
            entity1_id   => $self->data->{entity1}{id},
            attributes   => $self->data->{attributes},
            link_type_id => $self->data->{link_type}{id},
            begin_date   => $self->data->{begin_date},
            end_date     => $self->data->{end_date},
            ended        => $self->data->{ended},
            link_order   => $self->data->{link_order} // 0,
        });

    $self->entity_id($relationship->id);

    if ($self->c->model('CoverArt')->can_parse($link_type->name)) {
        my $release = $self->c->model('Release')->get_by_id(
            $self->data->{entity0}{id}
        );
        $self->c->model('Relationship')->load_subset([ 'url' ], $release);
        $self->c->model('CoverArt')->cache_cover_art($release);
    }
}

sub reject
{
    my $self = shift;
    $self->c->model('Relationship')->delete(
        $self->data->{type0},
        $self->data->{type1},
        $self->entity_id
    );

    my $link_type = $self->c->model('LinkType')->get_by_id(
        $self->data->{link_type}{id},
    );

    if ($self->c->model('CoverArt')->can_parse($link_type->name)) {
        my $release = $self->c->model('Release')->get_by_id(
            $self->data->{entity0}{id}
        );
        $self->c->model('Relationship')->load_subset([ 'url' ], $release);
        $self->c->model('CoverArt')->cache_cover_art($release);
    }
}

sub allow_auto_edit {
    my ($self) = @_;

    if ($self->data->{type0} eq "recording" && $self->data->{type1} eq "work") {
        return 1;
    }

    return 0;
}

before restore => sub {
    my ($self, $data) = @_;
    $data->{link_type}{long_link_phrase} =
        delete $data->{link_type}{short_link_phrase}
            if exists $data->{link_type}{short_link_phrase};

    $self->restore_int_attributes($data) unless defined $data->{edit_version};
};

sub editor_may_edit {
    my ($self, $opts) = @_;

    my $lt = $opts->{link_type};
    return $self->editor_may_edit_types($lt->entity0_type, $lt->entity1_type);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
