package Net::Jabber::Protocol;

=head1 NAME

Net::Jabber::Protocol - Jabber Protocol Library

=head1 SYNOPSIS

  Net::Jabber::Protocol is a module that provides a developer easy access
  to the Jabber Instant Messaging protocol.  It provides high level functions
  to both Net::Jabber::Client and Net::Jabber::Transport.  These functions
  are automatically indluded in those modules through AUTOLOAD and delegates.

=head1 DESCRIPTION

  Protocol.pm seeks to provide enough high level APIs and automation of 
  the low level APIs that writing a Jabber Client/Transport in Perl is 
  trivial.  For those that wish to work with the low level you can do 
  that too, but those functions are covered in the documentation for 
  each module.

  Net::Jabber::Protocol provides functions to login, send and receive 
  messages, set personal information, create a new user account, manage
  the roster, and disconnect.  You can use all or none of the functions,
  there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For more information on writing a Client see Net::Jabber::Client.

  For more information on writing a Transport see Net::Jabber::Transport.

=head2 Basic Functions

    use Net::Jabber;

    $Con = new Net::Jabber::Client();    # From Net::Jabber::Client
    $Con->Connect(name=>"jabber.org");   #

      or

    $Con = new Net::Jabber::Transport(); #
    $Con->Connect(name=>"jabber.org",    # From Net::Jabber::Transport
		  secret=>"bob");        #


    $Con->SetCallBacks(message=>\&messageCallBack,
		       iq=>\&handleTheIQTag);

    $Con->Process();
    $Con->Process(5);

    $Con->Send($object);
    $Con->Send("<tag>XML</tag>");

    $Con->Disconnect();

=head2 ID Functions

    $id         = $Con->SendWithID($sendObj);
    $id         = $Con->SendWithID("<tag>XML</tag>");
    $receiveObj = $Con->SendAndReceiveWithID($sendObj);
    $receiveObj = $Con->SendAndReceiveWithID("<tag>XML</tag>");
    $yesno      = $Con->ReceivedID($id);
    $receiveObj = $Con->GetID($id);    
    $receiveObj = $Con->WaitForID($id);

=head2 Message Functions

    $Con->MessageSend(to=>"bob@jabber.org",
		      subject=>"Lunch",
		      body=>"Let's go grab some...\n";
		      thread=>"ABC123",
		      priority=>10);

=head2 Presence Functions

    $Con->PresenceSend();

=head2 Subscription Functions

    $Con->Subscription(type=>"subscribe",
		       jid=>"bob@jabber.org");

    $Con->Subscription(type=>"unsubscribe",
		       jid=>"bob@jabber.org");

    $Con->Subscription(type=>"subscribed",
		       jid=>"bob@jabber.org");

    $Con->Subscription(type=>"unsubscribed",
		       jid=>"bob@jabber.org");

=head2 IQ  Functions

    $Con->SetQueryDelegates("com:bar:foo"=>"Foo::Bar");

=head2 IQ::Auth Functions

    @result = $Con->AuthSend();
    @result = $Con->AuthSend(username=>"bob",
			     password=>"bobrulez",
			     resource=>"Bob");

=head2 IQ::Fneg Functions

    n/a

=head2 IQ::Info Functions

    n/a

=head2 IQ::Register Functions

    @result = $Con->RegisterSend(usersname=>"newuser",
				 resource=>"New User",
				 password=>"imanewbie");

=head2 IQ::Resource Functions

    n/a

=head2 IQ::Roster Functions

    %roster = $Con->RosterGet();
    $Con->RosterAdd(jid=>"bob@jabber.org");
    $Con->RosterRemove(jid=>"bob@jabber.org");


=head2 IQ::Time Functions

    %result = $Con->TimeQuery();
    %result = $Con->TimeQuery(to=>"bob@jabber.org");

    $Con->TimeSend(to=>"bob@jabber.org");

=head2 IQ::Version Functions

    %result = $Con->VersionQuery();
    %result = $Con->VersionQuery(to=>"bob@jabber.org");

    $Con->VersionSend(to=>"bob@jabber.org",
                      name=>"Net::Jabber",
                      ver=>"1.0a",
                      os=>"Perl");

=head2 X Functions

    $Con->SetXDelegates("com:bar:foo"=>"Foo::Bar");

=head1 METHODS

=head2 Basic Functions

    SetCallBacks(message=>function,  - sets the callback functions for
                 presence=>function,   the top level tags listed.  The
		 iq=>function)         available tags to look for are
                                       <message/>, <presence/>, and
                                       <iq/>.  If a packet is received
                                       with an ID then it is not sent
                                       to these functions, instead it
                                       is inserted into a LIST and can
                                       be retrieved by some functions
                                       we will mention later.

    Process(integer) - takes the timeout period as an argument.  If no
                       timeout is listed then the function blocks until
                       a packet is received.  Otherwise it waits that
                       number of seconds and then exits so your program
                       can continue doing useful things.  NOTE: This is
                       important for GUIs.  You need to leave time to
                       process GUI commands even if you are waiting for
                       packets.

                       IMPORTANT: You need to check the output of every
                       Process.  If you get an undef or "" then the 
                       connection died and you should behave accordingly.

    Send(object) - takes either a Net::Jabber::xxxxx object or an XML
    Send(string)   string as an argument and sends it to the server.

=head2 ID Functions

    SendWithID(object) - takes either a Net::Jabber::xxxxx object or an
    SendWithID(string)   XML string as an argument, adds the next
                         available ID number and sends that packet to
                         the server.  Returns the ID number assigned.
    
    SendAndReceiveWithID(object) - uses SendWithID and WaitForID to
    SendAndReceiveWithID(string)   provide a complete way to send and
                                   receive packets with IDs.  Can take
                                   either a Net::Jabber::xxxxx object
                                   or an XML string.  Returns the
                                   proper Net::Jabber::xxxxx object
                                   based on the type of packet received.

    ReceivedID(integer) - returns 1 if a packet has been received with
                          specified ID, 0 otherwise.

    GetID(integer) - returns the proper Net::Jabber::xxxxx object based
                     on the type of packet received with the specified
                     ID.  If the ID has been received the GetID returns
                     0.

    WaitForID(integer) - blocks until a packet with the ID is received.
                         Returns the proper Net::Jabber::xxxxx object
                         based on the type of packet received


    NOTE:  Only <iq/> officially support ids, so sending a <message/>, or 
           <presence/> with an id is a risk.  Both clients must support 
           this for these functions to work.


=head2 Message Functions

    MessageSend(hash) - takes the hash and passes it to SetMessage in
                        Net::Jabber::Message (refer there for valid
                        settings).  Then it sends the message to the
                        server.

=head2 Presence Functions

    PresenceSend() - sends an empty Presence to the server to tell it
                     that you are available

=head2 Subscription Functions

    Subscription(type=>string, - sends a Presence to the server to tell it
                 jid=>string)    to perform the subscription in type to the
                                 you to the specified JID.  The allowed
                                 types are:

                                 subscribe    - subscribe to JID's presence
                                 unsubscribe  - unsubscribe from JID's presence
                                 subscribed   - response to a subscribe
                                 unsubscribed - response to an unsubscribe
                                 
=head2 IQ Functions

    SetQueryDelegates(hash) - the hash gets sent to the 
                              Net::Jabber::Query::SetDelegates function.
                              For more information about this function,
                              read the manpage for Net::Jabber::Query.

=head2 IQ::Auth Functions

    AuthSend(username=>string, - takes all of the information and
             password=>string,   builds a Net::Jabber::IQ::Auth packet.
             resource=>string)   It then sends that packet to the
    AuthSend()                   server with an ID and waits for that
                                 ID to return.  Then it looks in
                                 resulting packet and determines if
                                 authentication was successful for not.
                                 If no hash is passed then it tries
                                 to open an anonymous session.  The
                                 array returned from AuthSend looks
                                 like this:
                                   [ type , message ]
                                 If type is "ok" then authentication
                                 was successful, otherwise message
                                 contains a little more detail about the
                                 error.

=head2 IQ::Fneg Functions

    n/a

=head2 IQ::Info Functions

    n/a

=head2 IQ::Register Functions

    RegisterSend(username=>string, - takes all of the information and
                 password=>string,   builds a Net::Jabber::IQ::Register
                 resource=>string)   packet.  It then sends that packet
                                     to the server with an ID and waits
                                     for that ID to return.  Then it
                                     looks in resulting packet and
                                     determines if registration was
                                     successful for not.  The array
                                     returned from RegisterSend looks
                                     like this:
                                       [ type , message ]
                                     If type is "ok" then registration
                                     was successful, otherwise message
                                     contains a little more detail about the
                                     error.

=head2 IQ::Resource Functions

    n/a

=head2 IQ::Roster Functions

    RosterGet() - sends an empty Net::Jabber::IQ::Roster tag to the
                  server so the server will send the Roster to the
                  client.  Then it takes the result and puts it into
                  the following data structure which it returns to
                  to the caller:

                  $roster{'bob@jabber.org'}->{name}         
                                      - Name you stored in the roster

                  $roster{'bob@jabber.org'}->{subscription} 
                                      - Subscription status 
                                        (to, from, both, none)

		  $roster{'bob@jabber.org'}->{ask}
                                      - The ask status from this user 
                                        (subscribe, unsubscribe)

		  $roster{'bob@jabber.org'}->{groups}
                                      - Array of groups that 
                                        bob@jabber.org is in
			  
    RosterAdd(jid=>string) - sends a packet asking that the jid be
                             added to the user's roster.

    RosterRemove(jid=>string) - sends a packet asking that the jid be
                             removed from the user's roster.

=head2 IQ::Time Functions

    TimeQuery(to=>string) - asks the jid specified for its local time.
    TimeQuery()             If the to is blank, then it queries the
                            server.  Returns a hash with the various 
                            items set:

                              $time{utc}     - Time in UTC
                              $time{tz}      - Timezone
                              $time{display} - Display string

    TimeSend(to=>string) - sends the current UTC time to the specified
                           jid.

=head2 IQ::Version Functions

    VersionQuery(to=>string) - asks the jid specified for its client
    VersionQuery()             version information.  If the to is blank,
                               then it queries the server.  Returns a
                               hash with the various items set:

                                 $version{name} - Name
                                 $version{ver}  - Version
                                 $version{os}   - Operating System/Platform

    VersionSend(to=>string,   - sends the specified version information
                name=>string,   to the jid specified in the to.
                ver=>string,
                os=>string)

=head2 X Functions

    SetXDelegates(hash) - the hash gets sent to the 
                          Net::Jabber::X::SetDelegates function.  For 
                          more information about this function, read 
                          the manpage for Net::Jabber::X.

=head1 AUTHOR

Revised by Ryan Eatmon in December 1999.

By Thomas Charron in July of 1999 for http://jabber.org..

Based on a screenplay by Jeremie Miller in May of 1999
for http://jabber.org/

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use vars qw($VERSION);

$VERSION = "1.0";

sub new {
  my $proto = shift;
  my $self = { };

  $self->{VERSION} = $VERSION;
  
  bless($self, $proto);
  return $self;
}


###########################################################################
#
# CallBack - Central callback function.  If a packet comes back with an ID
#            and the tag and ID have been registered then the packet is not
#            returned as normal, instead it is inserted in the LIST and
#            stored until the user wants to fetch it.  If the tag and ID
#            are not registered the function checks if a callback exists 
#            for this tag, if it does then that callback is called, 
#            otherwise the function drops the packet since it does not know
#            how to handle it.
#
###########################################################################
sub CallBack {
  shift;
  my $self = shift;
  my (@object) = @_;

  $self->debug("CallBack: received(",&Net::Jabber::BuildXML(@object),")");

  my $tag = $object[0];
  my $id;
  $id = $object[1]->[0]->{id} if (exists($object[1]->[0]->{id}));

  $self->debug("CallBack: tag($tag)");
  $self->debug("CallBack: id($id)") if ($id ne "");

  if ($self->CheckID($tag,$id)) {
    $self->debug("CallBack: found registry entry: tag($tag) id($id)");
    $self->DeregisterID($tag,$id);
    my $NJObject;
    $NJObject = new Net::Jabber::IQ(@object) 
      if ($tag eq "iq");
    $NJObject = new Net::Jabber::Presence(@object) 
      if ($tag eq "presence");
    $NJObject = new Net::Jabber::Message(@object) 
      if ($tag eq "message");
    $self->GotID($object[1]->[0]->{id},$NJObject);
  } else {
    $self->debug("CallBack: no registry entry");  
    if (exists($self->{CB}->{$tag})) {
      $self->debug("CallBack: goto user function($self->{CB}->{$tag})");
      &{$self->{CB}->{$tag}}(@object);
    } else {
      $self->debug("CallBack: no defined function.  Dropping packet.");
    }
  }
}


###########################################################################
#
# SetCallBacks - Takes a hash with top level tags to look for as the keys
#                and pointers to functions as the values.  The functions
#                are called and passed the XML::Parser::Tree objects
#                generated by XML::Stream.
#
###########################################################################
sub SetCallBacks {
  shift;
  my $self = shift;
  while($#_ >= 0) {
    my $func = pop(@_);
    my $tag = pop(@_);
    $self->debug("SetCallBacks: tag($tag) func($func)");
    $self->{CB}{$tag} = $func;
  }
}


###########################################################################
#
#  Process - If a timeout value is specified then the function will wait
#            that long before returning.  This is useful for apps that
#            need to handle other processing while still waiting for
#            packets.  If no timeout is listed then the function waits
#            until a packet is returned.  Either way the function exits 
#            as soon as a packet is returned.
#
###########################################################################
sub Process {
  shift;
  my $self = shift;
  my ($timeout) = @_;
  my ($status);

  $self->debug("Process: timeout($timeout)");

  if (!defined($timeout) || ($timeout eq "")) {
    while(1) {
      $status = $self->{STREAM}->Process();
      last if (($status != 0) || ($status eq ""));
      select(undef,undef,undef,.25);
    }
    $self->debug("Process: return($status)");
    return $status;
  } else {
    return $self->{STREAM}->Process($timeout);
  }
}


###########################################################################
#
# Send - Takes either XML or a Net::Jabber::xxxx object and sends that
#        packet to the server.
#
###########################################################################
sub Send {
  shift;
  my $self = shift;
  my $object = shift;

  if (ref($object) eq "") {
    $self->SendXML($object);
  } else {
    $self->SendXML($object->GetXML());
  }
}


###########################################################################
#
# SendXML - Sends the XML packet to the server
#
###########################################################################
sub SendXML {
  shift;
  my $self = shift;
  my($xml) = @_;
  $self->debug("SendXML: sent($xml)");
  $self->{STREAM}->Send($xml);
}


###########################################################################
#
# SendWithID - Take either XML or a Net::Jabber::xxxx object and send it
#              with the next available ID number.  Then return that ID so
#              the client can track it.
#
###########################################################################
sub SendWithID {
  shift;
  my $self = shift;
  my ($object) = @_;

  #------------------------------------------------------------------------
  # Take the current XML stream and insert an id attrib at the top level.
  #------------------------------------------------------------------------
  my $currentID = $self->{LIST}->{currentID};

  my $xml;
  if (ref($object) eq "") {
    $xml = $object;
    $xml =~ s/^(\<[^\>]+)(\>)/$1 id\=\'$currentID\'$2/;
    my ($tag) = ($xml =~ /^\<(\S+)\s/);
    $self->RegisterID($tag,$currentID);
  } else {
    $object->SetID($currentID);
    $xml = $object->GetXML();
    $self->RegisterID($object->GetTag(),$currentID);
  }

  #------------------------------------------------------------------------
  # Send the new XML string.
  #------------------------------------------------------------------------
  $self->SendXML($xml);

  #------------------------------------------------------------------------
  # Increment the currentID and return the ID number we just assigned.
  #------------------------------------------------------------------------
  $self->{LIST}->{currentID}++;
  return $currentID;
}


###########################################################################
#
# SendAndReceiveWithID - Take either XML or a Net::Jabber::xxxxx object and
#                        send it with the next ID.  Then wait for that ID
#                        to come back and return the response in a
#                        Net::Jabber::xxxx object.
#
###########################################################################
sub SendAndReceiveWithID {
  shift;
  my $self = shift;
  my ($object) = @_;

  my $id = $self->SendWithID($object);
  return $self->WaitForID($id);
}


###########################################################################
#
# ReceivedID - returns 1 if a packet with the ID has been received, or 0
#              if it has not.
#
###########################################################################
sub ReceivedID {
  shift;
  my $self = shift;
  my ($id) = @_;

  return 1 if exists($self->{LIST}->{$id});
  return 0;
}


###########################################################################
#
# GetID - Return the Net::Jabber::xxxxx object that is stored in the LIST
#         that matches the ID if that ID exists.  Otherwise return 0.
#
###########################################################################
sub GetID {
  shift;
  my $self = shift;
  my ($id) = @_;

  return $self->{LIST}->{$id} if $self->ReceivedID($id);
  return 0;
}


###########################################################################
#
# WaitForID - Keep looping and calling Process(1) to poll every second
#             until the response from the server occurs.
#
###########################################################################
sub WaitForID {
  shift;
  my $self = shift;
  my ($id) = @_;
  
  while(!$self->ReceivedID($id)) {
    return undef unless (defined($self->Process(0)));
  }
  return $self->GetID($id);
}


###########################################################################
#
# GotID - Callback to store the Net::Jabber::xxxxx object in the LIST at
#         the ID index.  This is a private helper function.
#
###########################################################################
sub GotID {
  shift;
  my $self = shift;
  my ($id,$object) = @_;

  $self->{LIST}->{$id} = $object;
}


###########################################################################
#
# CheckID - Checks the ID registry if this tag and ID have been registered.
#           0 = no, 1 = yes
#
###########################################################################
sub CheckID {
  shift;
  my $self = shift;
  my ($tag,$id) = @_;
  
  return 0 if ($id eq "");
  return exists($self->{IDRegistry}->{$tag}->{$id});
}


###########################################################################
#
# RegisterID - Register the tag and ID in the registry so that the CallBack
#              can know what to put in the ID list and what to pass on.
#
###########################################################################
sub RegisterID {
  shift;
  my $self = shift;
  my ($tag,$id) = @_;

  $self->{IDRegistry}->{$tag}->{$id} = 1;
}


###########################################################################
#
# DeregisterID - Delete the tag and ID in the registry so that the CallBack
#                can knows that it has been received.
#
###########################################################################
sub DeregisterID {
  shift;
  my $self = shift;
  my ($tag,$id) = @_;

  delete($self->{IDRegistry}->{$tag}->{$id});
}


###########################################################################
#
# MessageSend - Takes the same hash that Net::Jabber::Message->SetMessage
#               takes and sends the message to the server.
#
###########################################################################
sub MessageSend {
  shift;
  my $self = shift;

  my $mess = new Net::Jabber::Message();
  $mess->SetMessage(@_);
  $self->Send($mess);
}


###########################################################################
#
# PresenceSend - Sends a presence tag to announce your availability
#
###########################################################################
sub PresenceSend {
  shift;
  my $self = shift;
  my $presence = new Net::Jabber::Presence();
  $self->Send($presence);
}


###########################################################################
#
# PresenceProbe - Sends a presence probe to the server
#
###########################################################################
sub PresenceProbe {
  shift;
  my $self = shift;

  my $presence = new Net::Jabber::Presence();
  $presence->SetPresence(type=>"probe");
  $self->Send($presence);
}


###########################################################################
#
# Subscription - Sends a presence tag to perform the subscription on the
#                specified JID.
#
###########################################################################
sub Subscription {
  shift;
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
  
  if (($args{type} ne "subscribe") && ($args{type} ne "unsubscribe") &&
      ($args{type} ne "subscribed") && ($args{type} ne "unsubscribed")) {
    print STDERR "ERROR: Subscription must take one of the following types:\n";
    print STDERR "         subscribe, unsubscribe, subscribed, unsubscribed\n";
    exit(0);
  }
  if ($args{jid} eq "") {
    print STDERR "ERROR: You must specify a Jabber ID for the Subscription\n";
    exit(0);
  }

  my $presence = new Net::Jabber::Presence();
  $presence->SetPresence(type=>$args{type},
			 to=>$args{jid});
  $self->Send($presence);
}


###########################################################################
#
# SetQueryDelegates - Sets the delegates for the <query/> that you might
#                     see during the session.
#
###########################################################################
sub SetQueryDelegates {
  shift;
  my $self = shift;
  my $query = new Net::Jabber::Query;
  $query->SetDelegates(@_);
}


###########################################################################
#
# AuthSend - This is a self contained function to send a login iq tag with
#            an id.  Then wait for a reply what the same id to come back 
#            and tell the caller what the result was.
#
###########################################################################
sub AuthSend {
  shift;
  my $self = shift;

  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  #------------------------------------------------------------------------
  # If we have access to the SHA-1 digest algorithm then let's use it.
  # Remove the password fro the hash, create the digest, and put the
  # digest in the hash instead.
  #
  # Note: Concat the Session ID and the password and then digest that
  # string to get the server to accept the digest.
  #------------------------------------------------------------------------
  if ($self->{DIGEST} == 1) {
    if (exists($args{password})) {
      my $password = delete($args{password});
      my $digest = Digest::SHA1::sha1_hex($self->{SESSION}->{id}.$password);
      $args{digest} = $digest;
    }
  }

  #------------------------------------------------------------------------
  # Create a Net::Jabber::IQ object to send to the server
  #------------------------------------------------------------------------
  my $IQLogin = new Net::Jabber::IQ;
  my $IQAuth = $IQLogin->NewQuery("jabber:iq:auth");
  $IQAuth->SetAuth(%args);

  #------------------------------------------------------------------------
  # Send the IQ with the next available ID and wait for a reply with that 
  # id to be received.  Then grab the IQ reply.
  #------------------------------------------------------------------------
  $IQLogin = $self->SendAndReceiveWithID($IQLogin);

  #------------------------------------------------------------------------
  # From the reply IQ determine if we were successful or not.  If yes then 
  # return "".  If no then return error string from the reply.
  #------------------------------------------------------------------------
  return ( ($IQLogin->GetErrorType() ne "" ? $IQLogin->GetErrorType() : $IQLogin->GetErrorCode()) , $IQLogin->GetError() )
    if ($IQLogin->GetType() eq "error");
  return ("ok","");
}


###########################################################################
#
# RegisterSend - This is a self contained function to send a registration
#                iq tag with an id.  Then wait for a reply what the same
#                id to come back and tell the caller what the result was.
#
###########################################################################
sub RegisterSend {
  shift;
  my $self = shift;

  #------------------------------------------------------------------------
  # Create a Net::Jabber::IQ object to send to the server
  #------------------------------------------------------------------------
  my $IQ = new Net::Jabber::IQ;
  $IQ->SetIQ(type=>"set");
  my $IQRegister = $IQ->NewQuery("jabber:iq:register");
  $IQRegister->SetRegister(@_);

  #------------------------------------------------------------------------
  # Send the IQ with the next available ID and wait for a reply with that 
  # id to be received.  Then grab the IQ reply.
  #------------------------------------------------------------------------
  $IQ = $self->SendAndReceiveWithID($IQ);
  
  #------------------------------------------------------------------------
  # From the reply IQ determine if we were successful or not.  If yes then 
  # return "".  If no then return error string from the reply.
  #------------------------------------------------------------------------
  return ( $IQ->GetErrorType() , $IQ->GetError() )
    if ($IQ->GetType() eq "error");
  return ("ok","");
}


###########################################################################
#
# RosterAdd - Takes the Jabber ID of the user to add to their Roster and
#             sends the IQ packet to the server.
#
###########################################################################
sub RosterAdd {
  shift;
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  my $roster = $iq->NewQuery("jabber:iq:roster");
  my $item = $roster->AddItem();
  $item->SetItem(@_,
		 subscription=>"to");
  $self->Send($iq);
}


###########################################################################
#
# RosterAdd - Takes the Jabber ID of the user to remove from their Roster
#             and sends the IQ packet to the server.
#
###########################################################################
sub RosterRemove {
  shift;
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  my $roster = $iq->NewQuery("jabber:iq:roster");
  my $item = $roster->AddItem();
  $item->SetItem(@_,
		 subscription=>"remove");
  $self->Send($iq);
}


###########################################################################
#
# RosterGet - Sends an empty IQ to the server to request that the user's
#             Roster be sent to them.
#
###########################################################################
sub RosterGet {
  shift;
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  $iq->SetIQ(type=>"get");
  my $query = $iq->NewQuery("jabber:iq:roster");

  $iq = $self->SendAndReceiveWithID($iq);

  $query = $iq->GetQuery();
  my @items = $query->GetItems();

  my %roster;
  my $item;
  foreach $item (@items) {
    my $jid = $item->GetJID();
    $roster{$jid}->{name} = $item->GetName();
    $roster{$jid}->{subscription} = $item->GetSubscription();
    $roster{$jid}->{ask} = $item->GetAsk();
    $roster{$jid}->{groups} = [ $item->GetGroups() ];
  }

  return %roster;
}


###########################################################################
#
# TimeQuery - Sends an iq:time query to either the server or the specified
#             JID.
#
###########################################################################
sub TimeQuery {
  shift;
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $iq = new Net::Jabber::IQ();
  $iq->SetIQ(to=>$args{to}) if exists($args{to});
  $iq->SetIQ(type=>'get');
  my $time = $iq->NewQuery("jabber:iq:time");

  $self->Send($iq);
}


###########################################################################
#
# TimeSend - sends an iq:time packet to the specified user.
#
###########################################################################
sub TimeSend {
  shift;
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $iq = new Net::Jabber::IQ();
  $iq->SetIQ(to=>$args{to},
	     type=>'result');
  my $time = $iq->NewQuery("jabber:iq:time");
  $time->SetTime();

  $self->Send($iq);
}



###########################################################################
#
# VersionQuery - Sends an iq:version query to either the server or the 
#                specified JID.
#
###########################################################################
sub VersionQuery {
  shift;
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $iq = new Net::Jabber::IQ();
  $iq->SetIQ(to=>$args{to}) if exists($args{to});
  $iq->SetIQ(type=>'get');
  my $version = $iq->NewQuery("jabber:iq:version");

  $self->Send($iq);
}


###########################################################################
#
# VersionSend - sends an iq:version packet to the specified user.
#
###########################################################################
sub VersionSend {
  shift;
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $iq = new Net::Jabber::IQ();
  $iq->SetIQ(to=>delete($args{to}),
	     type=>'result');
  my $version = $iq->NewQuery("jabber:iq:version");
  $version->SetVersion(%args);

  $self->Send($iq);
}


###########################################################################
#
# SetXDelegates - Sets the delegates for the <x/> that you might see during
#                 the session.
#
###########################################################################
sub SetXDelegates {
  shift;
  my $self = shift;
  my $x = new Net::Jabber::X;
  $x->SetDelegates(@_);
}


1;
