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
for use with Gnucash. Quotes are picked from Yahoo finance in JSON format
and then parsed.
The files here are intended to replace and augment those that come with the
PERL Finance::Quote package (usually located in /usr/share/perl5/Finance)
The code here is based on the BSERO module for Romanian stocks documented
here: http://www.strainu.ro/projects/bse-stock-prices-in-gnucash/
The module is named BOMSE because the plan was to pick quotes from the
BOMbay Stock Exchange, but later changed to using Yahoo Finance.

The code here is licensed under the GPL v2. See the license file for the
full license.

Prerequisites:
==============
This module requires Perl (at least v5). This has been tested on Debian Wheezy
as of 2013 October. Although no other distributions or operating systems have
been tested yet, there should be no major problems. 
This module requires the JSON and Datetime modules installed for Perl.

Installation:
=============
Look at the commands in install.sh. Basically the following needs to be done:
Add "BOMSE" to the list of available methods in Quote.pm (located by default
in something like /usr/share/perl5/Finance directory). You can edit this file
by hand or try to apply the patch provided (Quotes.pm.patch). Next, copy the 
module (BOMSE.pm) along with the other modules (typically under
/usr/share/perl5/Finance/Quote/)

Testing:
========
Once installed, run the script "BOMSETest.pl" in a terminal. This is a test
script and will attempt to fetch quotes for a few stocks. If you see 
"not ok" anywhere the accompanying error message should tell you what has
failed. If you are behind a proxy you may need to set the http_proxy
environment variable. 

Usage:
======
Scrip names:
------------
Yahoo Finance identifies stocks by codes. Indian scrips have a name followed
by a two letter extension identifying the exchange.
e.g. State bank of India is SBIN.NS (on NSE) or SBI.BO (on BSE). Observe that
the scrip identifiers are not necessarily identical on different exchanges.
To look up the code visit http://in.finance.yahoo.com/. To double check, make
sure that the quote is available in the JSON format (See last section below).

With Gnucash:
-------------
In gnucash
- go to Tools>Security Editor. Select "Add".
- Fill up the following fields:
	+ Full name		:Name of stock as you want to see it.
	+ Symbol/Abbreviation	:The scrip name exactly as determined above, with the
				 exchange information (e.g. SBIN.BO)
	+ Type			:Not critical, suggest use of NSE or BSE
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
Yahoo Finance URL Formats, Where NAME is the scrip name (SUZLON, or RECLTD)
and XC is a two letter exchange code - BO for BSE (Bombay) and NS for NSE.
Note that the "NAME" might NOT be identical on different exchanges!
- JSON:	http://finance.yahoo.com/webservice/v1/symbols/NAME.XC/quote?format=json
- XML:	http://finance.yahoo.com/webservice/v1/symbols/NAME.XC/quote?format=xml

Migrating to F::Q 1.27 or later:
================================
This module is redundant with the availability of yahoo_json method in F::Q v1.27 and later.
To change over, follow these steps:
1. Run
	perl -MCPAN -e shell
as root. If you are behind a proxy make sure you export proxy settings in the $http_proxy variable.

2. At the CPAN run
	install Finance::Quote
**This will install the latest version of F::Q and overwrite the BOMSE module this project provides.**
3. After the update, exit to a user shell and run
	gnc-fq-check
and make sure you see yahoo_json in the output.
4. Tell gnucash to use the new method:
Open gnucash security editor. For each security, change the online quotes dropdown from bomse to yahoo_json.

	

