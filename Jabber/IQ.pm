##############################################################################
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the
#  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#  Boston, MA  02111-1307, USA.
#
#  Jabber
#  Copyright (C) 1998-1999 The Jabber Team http://jabber.org/
#
##############################################################################

package Net::Jabber::IQ;

=head1 NAME

Net::Jabber::IQ - Jabber Info/Query Library

=head1 SYNOPSIS

  Net::Jabber::IQ is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all {iq}->
  parts of a Jabber IQ.

=head1 DESCRIPTION

  Net::Jabber::IQ differs from the other Net::Jabber::* modules in that
  the XMLNS of the query is split out into more submodules under
  IQ.  For specifics on each module please view the documentation
  for each Net::Jabber::Query::* module.  To see the list of avilable
  namspaces and modules see Net::Jabber::Query.

  To initialize the IQ with a Jabber <iq/> you must pass it the 
  XML::Parser Tree array.  For example:

    my $iq = new Net::Jabber::IQ(@tree);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above, a Net::Jabber::IQ object is passed
  to the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my ($IQ) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new iq to send to the server:

    use Net::Jabber;

    $IQ = new Net::Jabber::IQ();
    $IQType = $IQ->NewQuery( type );
    $IQType->SetXXXXX("yyyyy");

  Now you can call the creation functions for the IQ, and for the <query/>
  on the new Query object itself.  See below for the <iq/> functions, and
  in each query module for those functions.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $to         = $IQ->GetTo();
    $toJID      = $IQ->GetTo("jid");
    $from       = $IQ->GetFrom();
    $fromJID    = $IQ->GetFrom("jid");
    $id         = $IQ->GetID();
    $type       = $IQ->GetType();
    $error      = $IQ->GetError();
    $errorCode  = $IQ->GetErrorCode();

    $queryTag   = $IQ->GetQuery();
    $queryTree  = $IQ->GetQueryTree();

    $str        = $IQ->GetXML();
    @iq         = $IQ->GetTree();

=head2 Creation functions

    $IQ->SetIQ(tYpE=>"get",
	       tO=>"bob@jabber.org",
	       query=>"info");

    $IQ->SetTo("bob@jabber.org");
    $IQ->SetFrom("me\@jabber.org");
    $IQ->SetType("set");

    $IQ->SetIQ(to=>"bob\@jabber.org",
               errorcode=>403,
               error=>"Permission Denied");
    $IQ->SetErrorCode(403);
    $IQ->SetError("Permission Denied");

    $IQObject = $IQ->NewQuery("jabber:iq:auth");
    $IQObject = $IQ->NewQuery("jabber:iq:roster");

    $iqReply = $IQ->Reply();
    $iqReply = $IQ->Reply("client");
    $iqReply = $IQ->Reply("transport");

=head2 Test functions

    $test = $IQ->DefinedTo();
    $test = $IQ->DefinedFrom();
    $test = $IQ->DefinedID();
    $test = $IQ->DefinedType();
    $test = $IQ->DefinedError();
    $test = $IQ->DefinedErrorCode();

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is 
                 going to receive the <iq/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <iq/>.  To get the JID object set 
                    the string to "jid", otherwise leave blank for the 
                    text string.

  GetType() - returns a string with the type <iq/> this is.

  GetID() - returns an integer with the id of the <iq/>.

  GetError() - returns a string with the text description of the error.

  GetErrorCode() - returns a string with the code of error.

  GetQuery() - returns a Net::Jabber::Query object that contains the data
               in the <query/> of the <iq/>.

  GetQueryTree() - returns an XML::Parser::Tree object that contains the 
                   data in the <query/> of the <iq/>.

  GetXML() - returns the XML string that represents the <iq/>. This 
             is used by the Send() function in Client.pm to send
             this object as a Jabber IQ.

  GetTree() - returns an array that contains the <iq/> tag in XML::Parser 
              Tree format.

=head2 Creation functions

  SetIQ(to=>string|JID,    - set multiple fields in the <iq/> at one
        from=>string|JID,    time.  This is a cumulative and over
        id=>string,          writing action.  If you set the "to"
        type=>string,        attribute twice, the second setting is
        errorcode=>string,   what is used.  If you set the status, and
        error=>string)       then set the priority then both will be in
                             the <iq/> tag.  For valid settings read the
                             specific Set functions below.

  SetTo(string) - sets the to attribute.  You can either pass a string
  SetTo(JID)      or a JID object.  They must be a valid Jabber 
                  Identifiers or the server will return an error message.
                  (ie.  jabber:bob@jabber.org, etc...)

  SetFrom(string) - sets the from attribute.  You can either pass a string
  SetFrom(JID)      or a JID object.  They must be a valid Jabber 
                    Identifiers or the server will return an error message.
                    (ie.  jabber:bob@jabber.org, etc...)

  SetType(string) - sets the type attribute.  Valid settings are:

                    get      request information
                    set      set information
                    result   results of a get

  SetErrorCode(string) - sets the error code of the <iq/>.
 
  SetError(string) - sets the error string of the <iq/>.
 
  NewQuery(string) - creates a new Net::Jabber::Query object with the 
                     namespace in the string.  In order for this function 
                     to work with a custom namespace, you must define and 
                     register that namespace with the IQ module.  For more 
                     information please read the documentation for 
                     Net::Jabber::Query.  NOTE: Jabber does not support
                     custom IQs at the time of this writing.  This was just
                     including in case they do at some point.

  Reply(type=>string) - creates a new IQ object and populates the to/from
                        fields.  The type will be set in the <iq/>.

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the <iq/>, 
                0 otherwise.

  DefinedFrom() - returns 1 if the from attribute is defined in the <iq/>, 
                  0 otherwise.

  DefinedID() - returns 1 if the id attribute is defined in the <iq/>, 
                0 otherwise.

  DefinedType() - returns 1 if the type attribute is defined in the <iq/>, 
                  0 otherwise.

  DefinedError() - returns 1 if <error/> is defined in the <iq/>, 
                   0 otherwise.

  DefinedErrorCode() - returns 1 if the code attribute is defined in
                       <error/>, 0 otherwise.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0021";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUG} = new Net::Jabber::Debug(usedefault=>1,
					  header=>"NJ::IQ");
  
  $self->{QUERY} = "";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::IQ") {
      return $_[0];
    } else {
      my @temp = @_;
      $self->{IQ} = \@temp;
      my $xmlns = $self->GetQueryXMLNS();
      if (exists($Net::Jabber::DELEGATES{query}->{$xmlns})) {
	my @queryTree = $self->GetQueryTree();
	$self->SetQuery($xmlns,@queryTree) if ($xmlns ne "");
      }
      my $xTree;
      foreach $xTree ($self->GetXTrees()) {
	my $xmlns = &Net::Jabber::GetXMLData("value",$xTree,"","xmlns");
	next if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
	$self->AddX($xmlns,@{$xTree});
      }
    }
  } else {
    $self->{IQ} = [ "iq" , [{}]];
  }

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD {
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "IQ";
  
  return "iq" if ($AUTOLOAD eq "GetTag");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{To}         = ["value","","to"];
$FUNCTIONS{get}->{From}       = ["value","","from"];
$FUNCTIONS{get}->{ID}         = ["value","","id"];
$FUNCTIONS{get}->{Type}       = ["value","","type"];
$FUNCTIONS{get}->{Error}      = ["value","error",""];
$FUNCTIONS{get}->{ErrorCode}  = ["value","error","code"];

$FUNCTIONS{set}->{ID}         = ["single","","","id","*"];
$FUNCTIONS{set}->{Type}       = ["single","","","type","*"];
$FUNCTIONS{set}->{Error}      = ["single","error","*","",""];
$FUNCTIONS{set}->{ErrorCode}  = ["single","error","","code","*"];

$FUNCTIONS{defined}->{To}         = ["existence","","to"];
$FUNCTIONS{defined}->{From}       = ["existence","","from"];
$FUNCTIONS{defined}->{ID}         = ["existence","","id"];
$FUNCTIONS{defined}->{Type}       = ["existence","","type"];
$FUNCTIONS{defined}->{Error}      = ["existence","error",""];
$FUNCTIONS{defined}->{ErrorCode}  = ["existence","error","code"];


##############################################################################
#
# GetQuery - returns a Net::Jabber::Query object that contains the <query/>
#
##############################################################################
sub GetQuery {
  my $self = shift;
  $self->{DEBUG}->Log2("GetQuery: return($self->{QUERY})");
  return $self->{QUERY} if ($self->{QUERY} ne "");
  return;
}


##############################################################################
#
# GetQueryTree - returns an XML::Parser::Tree object of the <query/> tag
#
##############################################################################
sub GetQueryTree {
  my $self = shift;
  $self->MergeQuery();
  $self->MergeX();
  return &Net::Jabber::GetXMLData("tree",$self->{IQ},"*");
}


##############################################################################
#
# GetQueryXMLNS - returns the xmlns of the <query/> tag
#
##############################################################################
sub GetQueryXMLNS {
  my $self = shift;
  $self->MergeQuery();
  $self->MergeX();
  return &Net::Jabber::GetXMLData("value",$self->{IQ},"*","xmlns");
}


##############################################################################
#
# GetX - returns an array of Net::Jabber::X objects.  If a namespace is 
#        requested then only objects from that name space are returned.
#
##############################################################################
sub GetX {
  my $self = shift;
  my($xmlns) = @_;
  my @xTags;
  my $xTag;
  foreach $xTag (@{$self->{XTAGS}}) {
    push(@xTags,$xTag) if (($xmlns eq "") || ($xTag->GetXMLNS() eq $xmlns));
  }
  return @xTags;
}


##############################################################################
#
# GetXTrees - returns an array of XML::Parser::Tree objects of the <x/> tags
#
##############################################################################
sub GetXTrees {
  my $self = shift;
  $self->MergeX();
  my ($xmlns) = @_;
  my $xTree;
  my @xTrees;
  foreach $xTree (&Net::Jabber::GetXMLData("tree array",$self->{IQ},"*","xmlns",$xmlns)) {
    push(@xTrees,$xTree);
  }
  return @xTrees;
}

##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeQuery();
  $self->MergeX();
  return &Net::Jabber::BuildXML(@{$self->{IQ}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;
  $self->MergeQuery();
  $self->MergeX();
  return @{$self->{IQ}};
}


##############################################################################
#
# SetIQ - takes a hash of all of the things you can set on an <iq/> and sets
#         each one.
#
##############################################################################
sub SetIQ {
  my $self = shift;
  my %iq;
  while($#_ >= 0) { $iq{ lc pop(@_) } = pop(@_); }

  $self->SetID($iq{id}) if exists($iq{id});
  $self->SetTo($iq{to}) if exists($iq{to});
  $self->SetFrom($iq{from}) if exists($iq{from});
  $self->SetType($iq{type}) if exists($iq{type});
  $self->SetErrorCode($iq{errorcode}) if exists($iq{errorcode});
  $self->SetError($iq{error}) if exists($iq{error});
}


##############################################################################
#
# SetTo - sets the to attribute in the <iq/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID("full");
  }
  return unless ($to ne "");
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <iq/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID("full");
  }
  return unless ($from ne "");
  &Net::Jabber::SetXMLData("single",$self->{IQ},"","",{from=>$from});
}


##############################################################################
#
# NewQuery - calls SetQuery to create a new Net::Jabber::Query object, sets 
#            the xmlns and returns a pointer to the new object.
#
##############################################################################
sub NewQuery {
  my $self = shift;
  my ($xmlns) = @_;
  return if !exists($Net::Jabber::DELEGATES{query}->{$xmlns});
  my $query = $self->SetQuery($xmlns);
  $query->SetXMLNS($xmlns) if $xmlns ne "";
  return $query;
}


##############################################################################
#
# SetQuery - creates a new Net::Jabber::Query object, sets the internal
#            pointer to it, and returns a pointer to the new object.  This 
#            is a private helper function.
#
##############################################################################
sub SetQuery {
  my $self = shift;
  my ($xmlns,@queryTree) = @_;
  return if !exists($Net::Jabber::DELEGATES{query}->{$xmlns});
  $self->{DEBUG}->Log2("SetQuery: xmlns($xmlns) tree(",\@queryTree,")");
  eval("\$self->{QUERY} = new ".$Net::Jabber::DELEGATES{query}->{$xmlns}->{parent}."(\@queryTree);");
  $self->{DEBUG}->Log2("SetQuery: return($self->{QUERY})");
  return $self->{QUERY};
}
  

##############################################################################
#
# MergeQuery - rebuilds the <query/>in memory and merges it into the current
#              IQ tree. This is a private helper function.  It should be used
#              any time you need access the full <iq/> so that the <query/> 
#              tag is included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeQuery {
  my $self = shift;

  $self->{DEBUG}->Log2("MergeQuery: start");

  my $replaced = 0;

  return if ($self->{QUERY} eq "");

  $self->{DEBUG}->Log2("MergeQuery: selfQuery($self->{QUERY})");

  my $query = $self->{QUERY};
  my @queryTree = $query->GetTree();

  $self->{DEBUG}->Log2("MergeQuery: Check the old tags");
  $self->{DEBUG}->Log2("MergeQuery: length(",$#{$self->{IQ}->[1]},")");

  my $i;
  foreach $i (1..$#{$self->{IQ}->[1]}) {
    $self->{DEBUG}->Log2("MergeQuery: i($i)");
    $self->{DEBUG}->Log2("MergeQuery: data(",$self->{IQ}->[1]->[$i],")");
    if ((ref($self->{IQ}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{IQ}->[1]->[($i+1)]->[0]->{xmlns})) {
      $replaced = 1;
      $self->{IQ}->[1]->[$i] = $queryTree[0];
      $self->{IQ}->[1]->[($i+1)] = $queryTree[1];
    }
  }

  if ($replaced == 0) {
    $self->{DEBUG}->Log2("MergeQuery: new tag");
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = $queryTree[0];
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = $queryTree[1];
  }

  $self->{DEBUG}->Log2("MergeQuery: end");
}


##############################################################################
#
# NewX - calls AddX to create a new Net::Jabber::X object, sets the xmlns and 
#        returns a pointer to the new object.
#
##############################################################################
sub NewX {
  my $self = shift;
  my ($xmlns) = @_;
  return if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
  my $xTag = $self->AddX($xmlns);
  $xTag->SetXMLNS($xmlns) if $xmlns ne "";
  return $xTag;
}


##############################################################################
#
# AddX - creates a new Net::Jabber::X object, pushes it on the list, and 
#        returns a pointer to the new object.  This is a private helper 
#        function. 
#
##############################################################################
sub AddX {
  my $self = shift;
  my ($xmlns,@xTree) = @_;
  return if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
  $self->{DEBUG}->Log2("AddX: xmlns($xmlns) xTree(",\@xTree,")");
  my $xTag;
  eval("\$xTag = new ".$Net::Jabber::DELEGATES{x}->{$xmlns}->{parent}."(\@xTree);");
  $self->{DEBUG}->Log2("AddX: xTag(",$xTag,")");
  push(@{$self->{XTAGS}},$xTag);
  return $xTag;
}


##############################################################################
#
# RemoveX - removes all xtags that have the specified namespace.
#
##############################################################################
sub RemoveX {
  my $self = shift;
  my ($xmlns) = @_;
  return if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});

  foreach my $i (reverse(1..$#{$self->{IQ}->[1]})) {
    $self->{DEBUG}->Log2("RemoveX: i($i)");
    $self->{DEBUG}->Log2("RemoveX: data(",$self->{IQ}->[1]->[$i],")");

    if ((ref($self->{IQ}->[1]->[$i]) eq "") &&
	($self->{IQ}->[1]->[$i] eq "x") &&
	(ref($self->{IQ}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{IQ}->[1]->[($i+1)]->[0]->{xmlns}) &&
	$self->{IQ}->[1]->[($i+1)]->[0]->{xmlns} eq $xmlns) {
      splice(@{$self->{IQ}->[1]},$i,2);
    }
  }
  foreach my $index (reverse(0..$#{$self->{XTAGS}})) {
    splice(@{$self->{XTAGS}},$index,1) 
      if ($self->{XTAGS}->[$index]->GetXMLNS() eq $xmlns);
  }
}


##############################################################################
#
# MergeX - runs through the list of <x/> in the current iq and replaces
#          them with the list of <x/> in the internal list.  If any old <x/>
#          in the <iq/> are left, then they are removed.  If any new <x/>
#          are left in the interanl list, then they are added to the end of
#          the iq.  This is a private helper function.  It should be 
#          used any time you need access the full <iq/> so that all of
#          the <x/> tags are included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeX {
  my $self = shift;

  &Net::Jabber::printData("old: \$self->{IQ}",$self->{IQ});

  $self->{DEBUG}->Log2("MergeX: start");

  return if !(exists($self->{XTAGS}));

  $self->{DEBUG}->Log2("MergeX: xTags(",$self->{XTAGS},")");

  my $xTag;
  my @xTags;
  foreach $xTag (@{$self->{XTAGS}}) {
    push(@xTags,$xTag);
  }

  $self->{DEBUG}->Log2("MergeX: xTags(",\@xTags,")");
  $self->{DEBUG}->Log2("MergeX: Check the old tags");
  $self->{DEBUG}->Log2("MergeX: length(",$#{$self->{IQ}->[1]},")");

  foreach my $i (1..$#{$self->{IQ}->[1]}) {
    $self->{DEBUG}->Log2("MergeX: i($i)");
    $self->{DEBUG}->Log2("MergeX: data(",$self->{IQ}->[1]->[$i],")");

    if ((ref($self->{IQ}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{IQ}->[1]->[($i+1)]->[0]->{xmlns})) {
      $self->{DEBUG}->Log2("MergeX: found a namespace xmlns(",$self->{IQ}->[1]->[($i+1)]->[0]->{xmlns},")");
      next if !exists($Net::Jabber::DELEGATES{x}->{$self->{IQ}->[1]->[($i+1)]->[0]->{xmlns}});
      $self->{DEBUG}->Log2("MergeX: merge index($i)");
      my $xTag = pop(@xTags);
      $self->{DEBUG}->Log2("MergeX: merge xTag($xTag)");
      my @xTree = $xTag->GetTree();
      $self->{DEBUG}->Log2("MergeX: merge xTree(",\@xTree,")");
      $self->{IQ}->[1]->[($i+1)] = $xTree[1];
    }
  }

  $self->{DEBUG}->Log2("MergeX: Insert new tags");
  foreach $xTag (@xTags) {
    $self->{DEBUG}->Log2("MergeX: new tag");
    my @xTree = $xTag->GetTree();
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = "x";
    $self->{IQ}->[1]->[($#{$self->{IQ}->[1]}+1)] = $xTree[1];
  }

  $self->{DEBUG}->Log2("MergeX: end");

  &Net::Jabber::printData("new: \$self->{IQ}",$self->{IQ});
}


##############################################################################
#
# Reply - returns a Net::Jabber::IQ object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $reply = new Net::Jabber::IQ();

  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType(exists($args{type}) ? $args{type} : "result");

  my $selfQuery = $self->GetQuery();
  $reply->NewQuery($selfQuery->GetXMLNS());

  $reply->SetIQ(to=>$self->GetFrom(),
		from=>$self->GetTo()
	       );

  return $reply;
}


1;
