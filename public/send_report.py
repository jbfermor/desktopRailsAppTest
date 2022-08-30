import sys
import win32com.client
import datetime

account = sys.argv[1]
to = sys.argv[2]
name = sys.argv[3]
subject = sys.argv[4]
body = sys.argv[5]
attachment_path = sys.argv[6]

outlook = win32com.client.Dispatch('outlook.application')
#Create a folder to save REPORTS if dont exists
ns = outlook.GetNamespace("MAPI")
    
mail = outlook.CreateItem(0)
oacctouse = None
for oacc in outlook.Session.Accounts:
    if oacc.SmtpAddress == account:
        oacctouse = oacc
        break
if oacctouse:
    mail._oleobj_.Invoke(*(64209, 0, 8, 0, oacctouse))
mail.To = to
mail.Subject = name + subject
mail.HTMLBody = body
mail.Attachments.Add(attachment_path)
mail.Save()