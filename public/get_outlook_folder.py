import sys
import win32com.client

outlook = win32com.client.Dispatch('outlook.application')
ns = outlook.GetNamespace("MAPI")
draft = ns.Folders.Item(1).Folders.Item(17).Items
#report_folder = ns.Folders.Item(1).Folders.Item(17).Folders.Item("REPORTS")
account = "jbfermor@hotmail.com"
for item in draft:
  print(item)
  #oacctouse = None
  #for oacc in outlook.Session.Accounts:
  #  if oacc.SmtpAddress == account:
  #    oacctouse = oacc
  #    break
  #if oacctouse:
  #  item._oleobj_.Invoke(*(64209, 0, 8, 0, oacctouse))
  item.Send()


