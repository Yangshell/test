import re
import pandas as pd

datanum = 100

sID = r'Id:\s*(\d+)'
sTOTAL = r'total:\s*(\d+)'
sCUTOMER = r'cutomer:\s*(\w+)'
sRATING = r'rating:\s*(\d+)'
sVOTES = r'votes:\s*(\d+)'
sHELPFUL = r'helpful:\s*(\d+)'

IDlist = []
DATElist = []
CUSTOMERlist = []
RATINGlist = []
VOTESlist = []
HELPFULLlist = []
f = open('/Users/freedom/Downloads/amazon-meta.txt', 'r')
linenow = f.readline()
i=0
while(i<=datanum):
	while(1):
		if re.search(sID,linenow):
			idnow = re.search(sID,linenow)
			if idnow:
				#print("id:",idnow.group(1))
				i+=1
		if re.search(sTOTAL,linenow):
			rtotal = re.search(sTOTAL,linenow).group(1)
			#print(rtotal)
			for t in range(int(rtotal)):
				IDlist.append(idnow.group(1))
				linenow = f.readline()
				linesp = linenow.split(" ")
				#print(linesp)
				DATElist.append(linesp[4])
				CUSTOMERlist.append(re.search(sCUTOMER,linenow).group(1))
				RATINGlist.append(re.search(sRATING,linenow).group(1))
				VOTESlist.append(re.search(sVOTES,linenow).group(1))
				HELPFULLlist.append(re.search(sHELPFUL,linenow).group(1))
			break
		linenow = f.readline()
		#IDlist.append(idnow.group(1))
	linenow = f.readline()
f.close()
dateclean=pd.DataFrame({'ID':IDlist,'DATE':DATElist,'CUSTOMER':CUSTOMERlist,'RATING':RATINGlist,'VOTES':VOTESlist,'HELPFULL':HELPFULLlist})
print(dateclean.head())
columns = ['ID','DATE','CUSTOMER','RATING','VOTES','HELPFULL']
dateclean.to_csv('/Users/freedom/Desktop/dateclean.csv',encoding='utf-8',index=False,columns=columns)