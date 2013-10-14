#!/usr/bin/perl -w
#    This modules is based on the Finance::Quote::ASEGR module
#
#    The code has been modified by Andrei Cipu <strainu@strainu.ro> to be able to
#    retrieve stock information from the Bucharest Exchange in Romania.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#    02111-1307, USA
require 5.005;

use strict;
use Data::Dumper;
use JSON qw( decode_json );
package Finance::Quote::BOMSE;

use vars qw($VERSION $YIND_URL_HEAD $YIND_URL_TAIL);

use LWP::UserAgent;
use HTTP::Request::Common;
use HTML::TableExtract;

$VERSION='0.1';

my $YIND_URL_HEAD	= 'http://finance.yahoo.com/webservice/v1/symbols/';
my $YIND_URL_TAIL 	= '/quote?format=json';


sub methods { return ( india => \&bomse,
                       bomse => \&bomse,
                       ind => \&bomse); }
{
  my @labels = qw/name last date isodate p_change open high low close volume currency method exchange/;

  sub labels { return (india => \@labels,
                       bomse => \@labels,
                       ind => \@labels); }
}

sub bomse {

  my $quoter = shift;
  my @stocks = @_;
  my (%info,$reply,$url,$te,$ts,$row,@cells, $ce);
  my($my_date,$my_last,$my_p_change,$my_volume,$my_high,$my_low,$my_open);
  my $ua = $quoter->user_agent();


foreach my $stocks (@stocks)
    {
           
      $url = $YIND_URL_HEAD.$stocks.$YIND_URL_TAIL;
      $reply = $ua->request(GET $url);

      my $code=$reply->code;
      my $desc = HTTP::Status::status_message($code);
      my $headers=$reply->headers_as_string;
      my $body =  $reply->content;


      #Response variables available:
      #Response code: 			$code
      #Response description: 	$desc
      #HTTP Headers:				$headers
      #Response body				$body

		print "\nFetched $stocks. Hit a key. \n";
		my $user_input = <>;

		

		if ( $code == 200 )
        {
			#HTTP_Response succeeded - parse the data
			my $json_data = JSON::decode_json $body;				
			#print ref($json_data);
			#print "size of hash:  " . keys( $json_data ) . ".\n";
			
			my $json_data_count= $json_data->{'list'}{'meta'}{'count'};
			print "\n Got data with Count = $json_data_count \n"; 			
			
			if ($json_data_count != 1 )
			{
			 $info{$stocks, "success"}  =0;
			 $info{$stocks, "errormsg"}="Error retrieving quote for $stocks - no listing for this name found. Please check scrip name and the two letter extension (if any)";
			 
			}					
			else
			{			
			 $my_last = 50.0;
          $my_p_change = 1.5;
          $my_volume = 100;
          $my_high = 52.1;
          $my_low = 49.5;
          $my_open = 45.5;
          $my_date = "14.10.2013 15:47:00";
          
          $info{$stocks, "success"}  =1;
          $info{$stocks, "exchange"} ="Temporarily using Bucharest Stock Exchange";
          $info{$stocks, "method"}   ="bomse";
          $info{$stocks, "name"}     =$stocks;
          $info{$stocks, "last"}     =$my_last;
          $info{$stocks, "close"}    =$my_last;
          $info{$stocks, "p_change"} =$my_p_change;
          $info{$stocks, "volume"}   =$my_volume;
          $info{$stocks, "high"}     =$my_high;
          $info{$stocks, "low"}      =$my_low;
          $info{$stocks, "open"}     =$my_open;

          $quoter->store_date(\%info, $stocks, {eurodate => $my_date});

          $info{$stocks,"currency"} = "RON";

        }
        }

		  #HTTP request fail
        else
        {
        $info{$stocks, "success"}=0;
        $info{$stocks, "errormsg"}="Error retrieving quote for $stocks. Attempt to fetch the URL $url resulted in HTTP response $code ($desc)";
        }

		  # if( !$info{$stocks, "success" })
        # {
        #  $info{$stocks, "success"}=0;
        #  $info{$stocks, "errormsg"}="Error retrieving $stocks "; 
        # }
    }

	return wantarray() ? %info : \%info;
	return \%info;
}

1;

=head1 NAME

Finance::Quote::BOMSE - Obtain quotes from Bombay Stock Exchange Under Development

=head1 SYNOPSIS

    use Finance::Quote;

    $q = Finance::Quote->new;

    %info = Finance::Quote->fetch("bomse","tlv");  # Only query BSERO
    %info = Finance::Quote->fetch("india","brd"); # Failover to other sources OK.

=head1 DESCRIPTION

This module fetches information from the Bombay stock exchange. Under Development

This module is loaded by default on a Finance::Quote object. It's
also possible to load it explicity by placing "BOMSE" in the argument
list to Finance::Quote->new().

This module provides both the "bomse" and "india" fetch methods.
Please use the "india" fetch method if you wish to have failover
with future sources for Romanian stocks. Using the "bomse" method will
guarantee that your information only comes from the Bombay Stock Exchange

=head1 LABELS RETURNED

The following labels may be returned by Finance::Quote::BOMSE :
name, last, date, p_change, open, high, low, close,
volume, currency, method, exchange.

=head1 SEE ALSO

Bombay stock Exchange, BSERO

=cut
