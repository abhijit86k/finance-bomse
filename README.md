NSETOOLS PORT:
==============
This branch contains highly experimental code.
See the other README file.



NOTICE:
=======
The functionality of this module is now available in the Finance::Quote
Perl module v1.27 onwards. This repository will continue to exist
but will not be watched or maintained.

Introduction:
=============
BOMSE is a PERL Module to fetch stock quotes for indian stocks, developed
for use with Gnucash. Quotes are picked from the NSE website using the python
nsetools module in JSON format and then parsed.

The files here are intended to augment those that come with the
PERL Finance::Quote package (usually located in /usr/share/perl5/Finance)
The code here is based on the BSERO module for Romanian stocks documented
here: http://www.strainu.ro/projects/bse-stock-prices-in-gnucash/

The module is named BOMSE because the plan was to pick quotes from the
BOMbay Stock Exchange, but later changed to using Yahoo Finance, and 
when Yahoo closed down its JSON service, moved to python-nsetools

The code here is licensed under the GPL v2. See the license file for the
full license.

Prerequisites:
==============
This module requires Perl (at least v5). This has been tested on Debian Wheezy
as of 2013 October. Although no other distributions or operating systems have
been tested yet, there should be no major problems. 
This module requires the JSON and Datetime modules installed for Perl.
This version also requires python modules nsetools and its dependencies.

Installation:
=============
Look at the commands in install.sh. Basically the following needs to be done:
Add "BOMSE" to the list of available methods in Quote.pm (located by default
in something like /usr/share/perl5/Finance directory). You can edit this file
by hand or try to apply the patch provided (Quotes.pm.patch). Next, copy the 
module (BOMSE.pm) next to the other modules (typically under
/usr/share/perl5/Finance/Quote/)

Testing:
========
Once installed, run the script nsetoolsfetch.py with a single ticker as
argument. E.g.:

$./nsetoolsfetch.py INDIGO

This should print out a valid JSON-formatted quote.
If you get {"Sucess":0} it means that either yout ticker symbol is wrong, or
python is unable to fetch quotes.

Next, to test whether Perl modules are correctly installed, run 

$ gnc-fq-check

The output lists all quote fetch methods and should include "bomse"

Them to test quote fetch using bomse, run

$./BOMTest.pl

This is a test script and will attempt to fetch quotes for a few stocks. If
you see "not ok" anywhere the accompanying error message should tell you what
has failed. If you are behind a proxy you may need to set the http_proxy
environment variable. 

Usage:
======
Scrip names:
------------
Scrip names can be looked up on the NSE website https://www.nseindia.com/
Note that some equities such as ETFs or derivatives can be seen on the NSE
website but cannot be fetched. Try nsefetchtools to check which quotes can be
fetched. 

With Gnucash:
-------------
In gnucash
- go to Tools>Security Editor. Select "Add".
- Fill up the following fields:
	+ Full name		:Name of stock as you want to see it.
	+ Symbol/Abbreviation	:The scrip name exactly as determined above, with the
				 exchange information (e.g. SBIN)
	+ Type			:Not critical, suggest use of NSE
	+ ISIN...		:Blank
	+ Fraction traded 	:1/1
	+ Get online Quotes	:Selected
	+ Type of Source Quote	:Unknown > bomse
	+ Timezone		:Use local time
- Now hit OK, close the Security editor and save the Gnucash File.
- Go to Tools > Price Editor and click on Get online quotes.
See the gnucash manual on setting up automatic price retrieval.
(http://gnucash.org/docs/v2.4/C/gnucash-guide/invest-stockprice1.html#invest-stockprice-auto2)


Contributing:
=============
Visit the project page on github: https://github.com/abhijit86k/finance-bomse

Other useful stuff:
===================
Yahoo Finance seems to have permanently closed down the JSON Quote service.
	

