## Additional information

you need a folder data. this must be placed next to the main file
main.exe
/data/users.dart

in users.dart must be a definition of all users:
```
[
    { 
        "username": "something",
        "password": "blabla",
        "authLevel": 1
    }
]
```
authLevel describes the authorization levels for different pages an endpoints
currently implemented is: 0-3
* 0 - none
* 1 - basic (just read regular stuff)
* 2 - mod (moderator)
* 3 - admin

this only allowes basic auth.