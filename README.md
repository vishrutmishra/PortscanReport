#PortScan Report
##About
  > It is a Port Scanner using nmap and generates Report in csv format.  
  > A diff of report is also saved.  
  > It does an nmap scan in group of max range (default = 128)  
  
##Installation
  1. install ***bash***. _(generally comes preinstalled for Linux based OS)_
  2. install ***[nmap](http://nmap.org/book/install.html)***
  1. clone this repo `git clone https://github.com/vishrutmishra/PortscanReport.git`
  2. open terminal and run the script(s)

###How to run
  1. list the ips in ipList.lst OR Generate list by running resolveIP.sh  
  `./resolveIP.sh _ip_ > ipList.lst` where _ip_ is in format n.n.n.n/n.  
  To append an ip range use `./resolveIP.sh _ip_ >> ipList.lst`
  2. run getReport.sh to do port scan and generate report  
  `./getReport.sh ipList.lst`.  
  you can also mention `fast` for fast scan. (_same as mentioning `-T4` in nmap._)  
  `./getReport.sh ipList.lst fast`  

_you can use any name instead of iplist.lst_

###Changing Config/config.cfg
  - `_max_range` is the max value of range of IPs whose portscan is done simuntaneously. It is used in resolve.sh for giving ip list.
  - `_date` gives the preset date. It is used as a part of name to store the report. _You can also add time if you want to scan more than once a day_.
  - `_SCAN_OUTPUT` is name of folder in which port scan result on indivisual ports are stored.
  - `_ROOT` is used to give ROOT directory of the project. It calculates it by doing _pwd_.( as it is used in getReport.sh present in root directory )
  - `_OUTPUT` gives name of folder in which final result of scan ( concat of all port scan result ) are stored.
  - `_OPTIONS` are the options of nmap that are used. (_except -T4 that is decided based on whether fast is passed or not_)

##Architecture
 - **.csv** files are converted from xml files which are directly given by nmap.

 - **ipList.lst** is generated by _resloveIP.sh_ script. it contains all ips provided as an input _to resolveIP.sh_  in fixed ranges_(mentioned in config.cfg)_ like `n.n.n.n-range`.

 - **ipList.lst** is used as an input to _getReport.sh_. _ipList.lst_ contains list of ranges of ips in different lines.  
***for eg.*** output of `./resolveIP.sh 127.0.0.1/21` is:
  >  
  127.0.0.1-128  
  127.0.0.129-128  
  127.0.1.1-128   
  127.0.1.129-128   
  127.0.2.1-128   
  127.0.2.129-128   
  127.0.3.1-128   
  127.0.3.129-128  
  127.0.4.1-128  
  127.0.4.129-128  
  127.0.5.1-128  
  127.0.5.129-128  
  127.0.6.1-128  
  127.0.6.129-128  
  127.0.7.1-128  
  127.0.7.129-128  


 - **ipList.lst** is parsed line by line an deach line is given as an input to nmap for range of ip  
  you can create your own **ipList.lst** _(or any other name)_ as long as each line is a valid input of ip(s) for nmap command

 - **resolveIP.sh** takes input in form *n.n.n.n/n* and gives output in _n.n.n.n-range_ in multiple lines breaking the whole range into smaller parts which can be stored in a file to be used as an input for _getReport.sh_. If input provided is of any other form than *n.n.n.n/n* it wont work

##Developers
 - Vishrut Kumar Mishra ([github/vishrutmishra](https://github.com/vishrutmishra))
 - Aryan Raj ([github/aryanraj](https://github.com/aryanraj))
