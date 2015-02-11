#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#import os
import sys
#import smtplib
import csv

import markdown

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

FROM = 'Testilahettaja <testi@xd.fi>'
TO = 'Testivastaanottajat <vastaanottajat@xd.fi>'
TEMPLATE_HTML = open('template.html', 'r').read()

def read_recipients():
    recs = []
    with open('recipients.csv', 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=' ', quotechar='"')
        for row in reader:
            recs.append(row[0])
    return recs

def format_message(mail_from, mail_to, bcc=None, **kwargs):
    """Formats message as RFC822 email message"""
    msg = MIMEMultipart('alternative')
    msg['Subject'] = '[Vihreät] %s' % kwargs.get('subject', '(ei otsikkoa)')
    msg['From'] = mail_from
    msg['To'] = mail_to
    if bcc:
        msg['BCC'] = "; ".join(bcc)

    part_plain = MIMEText(kwargs.get('content_plain', '(puuttuu)'), 'plain')
    part_html = MIMEText(kwargs.get('content_html', '(puuttuu)'), 'html')

    msg.attach(part_plain)
    msg.attach(part_html)

    return msg.as_string()

def main(args):
    msg = format_message(subject='Testiviesti', content_html=markdown.markdown(open('viesti.md', 'r', encoding='utf-8').read()), content_plain=open('viesti.md', 'r', encoding='utf-8').read(), header='hdr', footer='ftr', nav='navii', bcc=read_recipients(), mail_to=TO, mail_from=FROM)
    print(msg)
    #s = smtplib.SMTP('localhost')
    #s.sendmail()
    #s.quit()

def run():
    args = []
    sys.exit(main(args))

if __name__ == "__main__":
    run()
