# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# police-uum.py
# Author: Maxim Dubinin (sim@gis-lab.info)
# About: Grab 112.ru data on участковые, creates two tables linked with unique id, policemen and locations they are responsible for.
# Created: 13:26 07.05.2013
# Usage example: python police-uum.py 45000000000
# ---------------------------------------------------------------------------

import urllib2
from bs4 import BeautifulSoup
import sys
import os
import ucsv as csv
from datetime import datetime

def download_list(link,cntry):
    try:
        u = urllib2.urlopen(link)
    except urllib2.URLError, e:
        if hasattr(e, 'reason'):
            print 'We failed to reach a server.'
            print 'Reason: ', e.reason
        elif hasattr(e, 'code'):
            print 'The server couldn\'t fulfill the request.'
            print 'Error code: ', e.code
        f_errors.write(cntry + "," + link + "\n")
        success = False
    else:
        f = open("countries/" + cntry + ".html","wb")
        f.write(u.read())
        f.close()
        print("Listing for " + cntry + " was downloaded")
        success = True
    return success
    
def get_country_codes(link):
    country_codes = []
    u = urllib2.urlopen(link)
    soup = BeautifulSoup(''.join(u.read()))
    sel = soup.find("select", { "name" : "countryId" })
    options = sel.findAll('option')
    for option in options:
        optval = option['value']
        if optval != '':
            country_codes.append(optval)
    
    return country_codes
    
def download_person(link,cntry,name):
    try:
        u = urllib2.urlopen(link)
    except urllib2.URLError, e:
        if hasattr(e, 'reason'):
            print 'We failed to reach a server.'
            print 'Reason: ', e.reason
        elif hasattr(e, 'code'):
            print 'The server couldn\'t fulfill the request.'
            print 'Error code: ', e.code
        f_errors.write(cntry + "," + link  + "," + name + "\n")
        success = False
    else:
        f = open("peoples/" + cntry + "_" + name + ".html","wb")
        f.write(u.read())
        f.close()
        print("Listing for " + name.encode("utf-8") + " was downloaded")
        success = True
    
    return success
    
def parse_list(cntry):
    cntry_list = open("countries/" + cntry + ".html")
    soup = BeautifulSoup(''.join(cntry_list.read()))
    maintable = soup.find("table", { "class" : "participantList sortable" })
    trs = maintable.findAll('tr')
    del trs[0]
    for tr in trs:
        tds = tr.findAll('td')
        name = list(tds[0].find("span", { "class" : "sortValue hidden" }).strings)[0]
        link = "http://kazan2013.ru" + tds[0].find('a')['href']
        nameru = list(tds[0].find('a').strings)[0]
        #if len(list(tds[1].strings)) != 0:
        #    gender = list(tds[1].strings)[0]
        #else:
        #    gender = "not set"
        if tds[2].find('a') != None:
            sports = list(tds[2].find('a').strings)[0]
            sports = sports.replace("\r\n","").strip()
            sportslink = "http://kazan2013.ru" + tds[2].find('a')['href']
        else:
            sports = ""
            sportslink = ""
        #cntry = list(tds[3].find('a').strings)[0]
        cntrylink = "http://kazan2013.ru" + tds[3].find('a')['href']
        
        success = download_person(link.replace("/ru/","/en/"),cntry,name)
        if success == True:
            lastname,firstname,gender,dob,day_b,month_b,year_b,height,weight,uniname,unicity,team = parse_person(cntry,name)
        else:
            lastname = firstname = gender = dob = day_b = month_b = year_b = height = weight = uniname = unicity = team = "error"
        
        #write to man file
        csvwriter.writerow(dict(NAME=name,
                                LINK=link,
                                NAMERU=nameru,
                                GENDER=gender,
                                SPORTS=sports,
                                SPORTSLINK=sportslink,
                                CNTRY=cntry,
                                CNTRYLINK=cntrylink,
                                LASTNAME=lastname,
                                FIRSTNAME=firstname,
                                DOB=dob,
                                DOB_DAY=day_b,
                                DOB_MNTH=month_b,
                                DOB_YEAR=year_b,
                                HEIGHT=height,
                                WEIGHT=weight,
                                UNINAME=uniname,
                                UNICITY=unicity,
                                TEAM=team))

def parse_person(cntry,name):
    f_person = open("peoples/" + cntry + "_" + name + ".html",'rb')
    soup = BeautifulSoup(''.join(f_person.read()))
    persinfotable = soup.findAll('table')[0]
    trs = persinfotable.findAll('tr')
    del trs[0]

    lastname = firstname = dob = day_b = month_b = year_b = height = weight = uniname = unicity = team = ""
    for tr in trs:
        tds = tr.findAll('td')
        trname = list(tds[0].strings)[0].strip()
        
        if trname == "Family name":
            lastname = list(tds[1].strings)[0].strip()
        elif trname == "Given name":
            firstname = list(tds[1].strings)[0].strip()
        elif trname == "Gender":
            gender = list(tds[1].find('div').strings)[0].strip()
        elif trname == "Birthdate":
            dob = list(tds[1].findAll('div')[0].strings)[0].strip()
            date_object = datetime.strptime(dob, '%d %B %Y')
            day_b = date_object.day
            month_b = date_object.month
            year_b = date_object.year
        elif trname == "Height (cm)":
            height = list(tds[1].strings)[0].strip()
        elif trname == "Weight (kg)":
            weight = list(tds[1].strings)[0].strip()
        elif trname == "University":
            uniname = list(tds[1].strings)[0].strip()
        elif trname == "University City":
            unicity = list(tds[1].strings)[0].strip()
        elif trname == "Teams":
            team = list(tds[1].find("span").strings)[0].strip()
    
    return lastname,firstname,gender,dob,day_b,month_b,year_b,height,weight,uniname,unicity,team
    
if __name__ == '__main__':
    args = sys.argv[1:]
    if len(args) == 1:
        country_codes = [args[0]] #use RUS for RUSSIA
    else:
        country_codes = get_country_codes(link = "http://kazan2013.ru/hide/ru/-240/Participant/List?isRelay=False&isAnimal=False&lastNameStarts=&sportId=&countryId=RUS")   
    
    f_errors = open("errors.log","a")
    
    fieldnames_data = ("NAME","LINK","NAMERU","SPORTS","SPORTSLINK","CNTRY","CNTRYLINK","LASTNAME","FIRSTNAME","GENDER","DOB","DOB_DAY","DOB_MNTH","DOB_YEAR","HEIGHT","WEIGHT","UNINAME","UNICITY","TEAM")
    for cntry in country_codes:
        link = "http://kazan2013.ru/hide/ru/-240/Participant/List?isRelay=False&isAnimal=False&lastNameStarts=&sportId=&countryId=" + cntry
        data_name = cntry + ".csv"
        
        f_data = open("countries/" + data_name,"wb")
        csvwriter = csv.DictWriter(f_data, fieldnames=fieldnames_data)
        
        success = download_list(link,cntry)
        if success == True:
            parse_list(cntry)
        else:
            f_errors.write(cntry + "\n")
        
    f_data.close()
    f_errors.close()