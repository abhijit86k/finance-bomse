#!/bin/bash

#1. Apply the patch to Quote.pm
#sudo patch /usr/share/perl5/Finance/Quote.pm ./Quotes.pm.patch

#2. Copy the new file into the Module
sudo cp ./BOMSE.pm /usr/share/perl5/Finance/Quote/BOMSE.pm
