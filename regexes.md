# Regexes to be used

## Find attempts to invalid user
'''
([a-zA-Z]+ [0-9]+ [0-9]+):[0-9]+:[0-9]+ ([a-zA-Z]+) sshd\[[0-9]+\]: Invalid user ([a-zA-Z0-9_]+) from ([0-9\.]+)
'''

## Find attempts to valid user

'''
([a-zA-Z]+ [0-9]+ [0-9]+):[0-9]+:[0-9]+ ([a-zA-Z]+) sshd\[[0-9]+\]: Failed password for ([a-zA-Z]+) from ([0-9.]+ )
'''
## Parsing failed logins
add capture groups around desired fields
```
[A-Za-z]+ +[0-9]+ [0-9]+ [a-zA-Z0-9_\-]+ [0-9. ]+
```
