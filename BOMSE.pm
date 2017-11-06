#!/usr/bin/perl -w
#    This module is based on the Finance::Quote::BSERO module
#
#    The code has been modified by Abhijit K to 
#    retrieve stock information for Indian Stocks from Yahoo Finance
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

package Finance::Quote::BOMSE;

require 5.005;

use strict;
use JSON qw( decode_json );
use vars qw($VERSION $YIND_URL_HEAD $YIND_URL_TAIL);
use LWP::UserAgent;
use HTTP::Request::Common;
use HTML::TableExtract;
use Time::Piece;

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
           
 	  #Call python:
	  my $nsetoolsfetch = `nsetoolsfetch.py $stocks` ;
	  my $quotedata = JSON::decode_json $nsetoolsfetch;

      if ( $quotedata->{'Success'} == 1 )
		{
		#{ print('Go'); }
		#Success

		  my $json_symbol 		=  $quotedata->{'symbol'};
          my $json_volume 		=  $quotedata->{'quantityTraded'};
          my $json_timestamp 	=  $quotedata->{'timestamp'};
          my $json_name 		=  $quotedata->{'companyName'};
          my $json_type 		=  $quotedata->{'series'};
          my $json_price 		=  $quotedata->{'lastPrice'};
		  my $json_high52 		=  $quotedata->{'high52'};
		  my $json_low52 		=  $quotedata->{'low52'};
		  my $json_dayhigh 		=  $quotedata->{'dayHigh'};
		  my $json_daylow 		=  $quotedata->{'dayLow'};
		  my $json_open 		=  $quotedata->{'open'};


          $my_p_change = +0.0;

          $info{$stocks, "success"}  =1;
          $info{$stocks, "exchange"} ="Sourced from NSE via python-nsetools (as JSON)";
          $info{$stocks, "method"}   ="bomse";
          $info{$stocks, "name"}     =$stocks.' ('.$json_name.')';
          $info{$stocks, "last"}     =$json_price;
          $info{$stocks, "close"}    =$json_price;
          $info{$stocks, "p_change"} =$my_p_change;
          $info{$stocks, "volume"}   =$json_volume;
          $info{$stocks, "high"}     =$json_dayhigh;
          $info{$stocks, "low"}      =$json_daylow;
          $info{$stocks, "open"}     =$json_open;
		  
          $my_date = localtime($json_timestamp)->strftime('%d.%m.%Y %T');
			#print $my_date;
          $quoter->store_date(\%info, $stocks, {eurodate => $my_date});
          $info{$stocks,"currency"} = "INR";
		}

	  else
			{
			#{ print('Fail'); }
			#Fail
			 $info{$stocks, "success"}  =0;
			 $info{$stocks, "errormsg"}="Error retrieving quote for $stocks - no listing for this name found. Please check scrip name and the two letter extension (if any)";
			}
	
}

	return wantarray() ? %info : \%info;
	return \%info;
}

1;

=head1 NAME

Finance::Quote::BOMSE - Obtain quotes from Yahoo Finance for Indian stocks

=head1 SYNOPSIS

    use Finance::Quote;

    $q = Finance::Quote->new;

    %info = Finance::Quote->fetch("bomse","SBIIN.NS");

=head1 DESCRIPTION

This module fetches information from Yahoo as JSON

This module is loaded by default on a Finance::Quote object. It's
also possible to load it explicity by placing "BOMSE" in the argument
list to Finance::Quote->new().

This module provides the "bomse" fetch method.

=head1 LABELS RETURNED

The following labels may be returned by Finance::Quote::BOMSE :
name, last, date, p_change, open, high, low, close,
volume, currency, method, exchange.

=head1 SEE ALSO

BSERO

=cut
