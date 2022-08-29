import win32com.client
outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")

for account in outlook.Stores:
  print(account)# Storing the different outlook profiles


