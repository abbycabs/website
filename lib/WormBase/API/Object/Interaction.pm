package WormBase::API::Object::Interaction;
use Moose;

with 'WormBase::API::Role::Object';
extends 'WormBase::API::Object';

=pod 

=head1 NAME

WormBase::API::Object::Interaction

=head1 SYNPOSIS

Model for the Ace ?Interaction class.

=head1 URL

http://wormbase.org/species/interaction

=head1 METHODS/URIs

=cut

has 'effector' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $object = $self->object;

    }
);

has 'effected' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $object = $self->object;
        my @effecteds;
        eval { @effecteds = $object->Interaction_type->Effected->col; };
        return \@effecteds;
    }
);

# has 'non_directional_interactors' => (
#     is      => 'ro',
#     lazy    => 1,
#     default => sub {
#         my $self = shift;
#         my $object = $self->object;
#         my $it = $object->Interaction_type;
#         my @non_directional_interactors;
#         
#         eval {@non_directional_interactors =
#               $self->Interaction_type->Non_directional->col;
#         };
#         return \@non_directional_interactors;
#     }
# );

#######################################
#
# The Overview Widget
#
#######################################

=head2 Overview

=cut

# sub name { }
# Supplied by Role; POD will automatically be inserted here.
# << include name >>

# sub remarks {}
# Supplied by Role; POD will automatically be inserted here.
# << include remarks >>

=head3 interactor

This method will return a data structure with the interactors.

=over

=item PERL API

 $data = $model->interactor();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/interactor

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub interactor {
    my $self   = shift;
    my $object = $self->object;
    my @genes  = $object->Interactor;
    @genes = map { $self->_pack_obj( $_, $_->Public_name ) } @genes;
    return {
        description => 'The genes in this interaction',
        data        => @genes ? \@genes : undef,
    };
}

=head3 interaction_type

This method will return a data structure with the interaction_type.

=over

=item PERL API

 $data = $model->interaction_type();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/interaction_type

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub interaction_type {
    my $self   = shift;
    my $object = $self->object;
    my $type   = $object->Interaction_type;
    my %interaction_info;

#     $interaction_info{'effector'} = $self->_pack_obj($type->Effector->col)
#       if $type->Effector;
#     $interaction_info{'effected'} = $self->_pack_obj( $type->Effected )
#       if $type->Effected;
#     if ( $type->Non_directional ) {
#         my @genes = map { $self->_pack_obj($_) } $type->Non_directional;
#         $interaction_info{'non_directional'} = \@genes;
#     }
    return {
        description => 'The type of interaction.',
        data        => {
            type             => $type,
            interaction_info => \%interaction_info,
        }
    };
}

=head3 phenotype

This method will return a data structure with phenotypes observed with the interaction.

=over

=item PERL API

 $data = $model->phenotype();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/phenotype

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub phenotype {
    my $self      = shift;
    my $object    = $self->object;
    my $it        = $object->Interaction_type;
    my $phenotype = $it->Interaction_phenotype->right
      if $it->Interaction_phenotype;
    my $phenotype_name = $phenotype->Primary_name if $phenotype;
    my $data_pack = $self->_pack_obj( $phenotype, $phenotype_name );

    return {
        'data' => $data_pack,
        'description' =>
          'description of the phenotype associated with this interaction'
    };
}

=head3 rnai

This method will return a data structure with rnais involved in the interaction.

=over

=item PERL API

 $data = $model->rnai();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/rnai

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub rnai {
    my $self      = shift;
    my $object    = $self->object;
    my $it        = $object->Interaction_type;
    my $rnai      = $it->Interaction_RNAi->right if $it->Interaction_RNAi;
    my $data_pack = $self->_pack_obj($rnai);
    return {
        'data' => $data_pack,
        'description' =>
          'description of the rnai involved with this interaction'
    };
}

###########################
#
# The Interactors Widget
#
###########################

=head2 Interactors

=cut

=head3 effector_data

This method will return a data structure with effector_data for the interaction.

=over

=item PERL API

 $data = $model->effector_data();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/effector_data

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub effector_data {
    my $self      = shift;
    my $data_pack = $self->_interactor_data('effector');

    return {
        data        => $data_pack,
        description => 'data on the effector genes of the interaction'
    };
}

=head3 effected_data

This method will return a data structure with effected_data for the interaction.

=over

=item PERL API

 $data = $model->effected_data();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/effected_data

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub effected_data {
    my $self      = shift;
    my $data_pack = $self->_interactor_data('effected');

    return {
        data        => $data_pack,
        description => 'data on the effected genes of the interaction'
    };
}

=head3 non_directional_data

This method will return a data structure with date for the non_directional interactions.

=over

=item PERL API

 $data = $model->non_directional_data();

=item REST API

B<Request Method>

GET

B<Requires Authentication>

No

B<Parameters>

An Interaction id (eg WBInteraction0000779)

B<Returns>

=over 4

=item *

200 OK and JSON, HTML, or XML

=item *

404 Not Found

=back

B<Request example>

curl -H content-type:application/json http://api.wormbase.org/rest/field/interaction/WBInteraction0000779/non_directional_data

B<Response example>

<div class="response-example"></div>

=back

=cut 

sub non_directional_data {
    my $self      = shift;
    my $data_pack = $self->_interactor_data('non_directional');

    return {
        data => $data_pack,
        description =>
          'data on the non_directional components of the interaction'
    };
}

#######################################
#
# The External Links widget
#
#######################################

=head2 External Links

=cut

# sub xrefs {}
# Supplied by Role; POD will automatically be inserted here.
# << include xrefs >>

#######################################
#
# Internal Methods
#
#######################################

sub _interactor_data {
    my $self            = shift;
    my $interactor_type = shift;         ## efffector, effected, non_directional
    my $object          = $self->object;
    my %data;
    my $desc = 'notes';
    my @data_pack;
	my $it = $object->Interaction_type;
    my $interactor_ar;

    if ( $interactor_type =~ /effector/ ) {
        my @effectors = $it->Effector->col if $it->Effector;
        $interactor_ar = \@effectors;    
    }
    elsif ( $interactor_type =~ /effected/ ) {
        my @effecteds = $it->Effected->col if $it->Effected; 
        $interactor_ar = \@effecteds;
    }
    else {
        my @non_directional_interactors = $it->Non_directional->col if $it->Non_directional;
        $interactor_ar = \@non_directional_interactors;
    }
	
 	foreach my $interactor (@$interactor_ar) {
 		my $gene_data    = $self->_pack_obj($interactor,$interactor->Public_name);     
        my @interactions = $interactor->Interaction;
		my $interaction_count = @interactions;

        my @cds = $interactor->Corresponding_CDS;
        my @proteins;
        eval{ @proteins =
          map { $interactor->Corresponding_protein( -fill => 1 ) } @cds
          if (@cds);};
        my @protein_data_set;

        foreach my $protein (@proteins) {
            my $protein_data = $self->_pack_obj($protein);
            push @protein_data_set, $protein_data;
        }

         my $interactor_data = {
            'gene'        => $gene_data,
            'interactions' => "$interaction_count",
            'protein'     => \@protein_data_set,
         };
         push @data_pack, $interactor_data;
 	}
     return \@data_pack; ## $interactor_ar; 
}

__PACKAGE__->meta->make_immutable;

1;

