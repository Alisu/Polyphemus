import re,sys
t=open(sys.argv[1]).read()
states=re.split(r'\nState \d+: ',t)
prev={}
for i,s in enumerate(states[1:],1):
    head=s.split('\n')[0].split(' line')[0]
    vals=dict(re.findall(r'/\\ (\w+) = (.+)',s))
    diff={k:v for k,v in vals.items() if prev.get(k)!=v} if prev else {}
    if 'f' in diff and 'f' in prev:
        old=dict(re.findall(r'(\w+) \|-> (\w+)',prev['f'])); new=dict(re.findall(r'(\w+) \|-> (\w+)',diff['f']))
        diff['f']={k:v for k,v in new.items() if old.get(k)!=v}
    print(i, head, '' if i==1 else diff)
    prev=vals
