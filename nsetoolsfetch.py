#!/usr/bin/python

#imports
import sys, logging, json
from datetime import datetime
from datetime import timedelta

#logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
#logging.basicConfig(stream=sys.stderr, level=logging.CRITICAL)
#logging.basicConfig(stream=sys.stderr, level=logging.INFO)

argnum = len(sys.argv)
scrip = str(sys.argv[1])

#logging.debug('A debug message!')
#logging.info('A debug message!')
#logging.critical('This is a critical message')

if argnum != 2:
	logging.info('More than one argument to script. Currently not supported')	
	print('');
	exit();

logging.info('Attempting to fetch quotes for ' + scrip + '...');

from nsetools import Nse
nse = Nse()

if nse.is_valid_code(scrip):
	logging.info('Scrip name is valid')
	#Add Success attrib in JSON
	q=nse.get_quote(scrip, as_json=True)
	#q = '{ }';
	quotedata = json.loads(q)
	quotedata['Success'] = 1;
	#Add timestamp:
	#quote_time =  datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S+0000");

	T_UTC = datetime.utcnow()
	T_in  = T_UTC + timedelta(hours=5, minutes=30)
	quote_time =  T_in.strftime("%s");
	quotedata['timestamp'] = quote_time;
	q=json.dumps(quotedata);
	print(q)
else:
	logging.info('Invalid scrip name. Check https://www.nseindia.com to get correct scrip name.')
	#Create JSON with fail attrib
	FailObjectString = '{"Success": 0}';
	#FailObject_JSON = json.dumps(FailObject);
	print(FailObjectString);
exit()
