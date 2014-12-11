module quandl;
import std.stdio;
import std.string;
import std.net.curl;

/**
	quandl.d

	Based on quandl.h by Zhiwei Fu [Created on: 30/09/2013 (Updated on 10/09/2014)]
	Hacked on by Laeeth Isharc 2014 to port to D
	Not pretty but it works (I hope).  Use at your own risk.


 	This programme is free software. It is developed by Dr Zhiwei Fu as a product
	contributing to quandl.com.
	This programme is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY, without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

// original imported iostream,fstream (perror),string,string.h,sys/socket,netinet/in.h, arpa/inet.g,netdb.h,netinet/tcp.h,time.h

struct quandlapi_t {
// To store the token in "AuthCode", which is a public variable in the class.
	string AuthCode="";
	this(string authcode)
	{
		AuthCode=authcode;
	}
}

quandlapi_t quandlapi;

/**
	To download file from the website defined by the first argument.
	To determine the website address by the token stored in "code"
	and call the function "download"
	*/

void get(string code, string type)
{
	type=toLower(type);
	string order = "asc";
	string website = "https://www.quandl.com/api/v1/datasets/" ~ code ~ "." ~ type ~ "?sort_order=" ~ order;
	if (quandlapi.AuthCode.length == 0){
		writefln("It would appear you are not using an authentication"
				 " token. Please visit http://www.quandl.com/help/c++"
				" or your usage may be limited.\n");
	}
	else {
		website ~= "&auth_token=" ~ quandlapi.AuthCode;
	}

	string FileName;
	auto iLength = code.length;
	foreach(i;0 .. iLength)
	{
		if (code[i] == '/')
		{
			FileName = code[i+1.. iLength];
			break;
		}
	}
	debug{
		writefln("%s,%s", iLength,FileName);
		writefln(website);
	}
	download(website, FileName ~ "." ~ type);
	return;
}
// All parameters are prescribed by users.
// 1. Quandl code;
// 2. Ascending/descending order;
// 3. Start date;
// 4. End date;
// 5. Transformation;
// 6. collapse;
// 7. Rows;
// 8. Output type
// There are 7 optional arguments compared to the one above.
void get(string code, string order, string StartDate, string EndDate, string transformation, string collapse, string rows, string filetype)
{
	filetype=toLower(filetype);
	order = toLower(order);
	if (order.length==0)
		order="asc";
	if (filetype.length==0)
		filetype="json";

	string website = "http://www.quandl.com/api/v1/datasets/" ~ code ~ "." ~ filetype ~ "?sort_order=" ~ order;
	if (quandlapi.AuthCode.length == 0) {
		writefln(	"It appear you are not using an authentication"
					" token. Please visit http://www.quandl.com/help/api for getting one"
					" ; otherwise your usage may be limited.");
	}
	else {
		website ~= "&auth_token=" ~ quandlapi.AuthCode;
	}
	if (StartDate.length>0)
		website ~= "&trim_start=" ~ StartDate;
	if (EndDate.length>0)
		website ~= "&trim_end=" ~ EndDate;
	if (transformation.length>0)
		website ~= "&transformation=" ~ transformation;
	if (collapse.length>0)
		website ~= "&collapse=" ~ collapse;
	if (rows.length>0)
		website ~= "&rows=" ~ rows;
	string FileName;
	auto iLength = code.length;
	foreach(i;0 .. iLength)
	{
		if(code[i] == '/')
		{
			FileName = code[i+1 .. iLength ];
			break;
		}
	}
	debug{writefln(website);}
	debug{writefln(FileName);}
	download(website, FileName ~ "." ~ filetype);
}

unittest
{
	quandlapi.AuthCode="";
	get("BAVERAGE/ANX_HKUSD","csv");
	get("BAVERAGE/ANX_HKUSD","asc","1990-01-01","2015-01-01","","","","json");
}