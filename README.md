# SwiftyDictionaryInflater

A flat structured dictionary like the following

```Swift
let dic:[String: String] = [
    "auth/type":"saml2.web.post",
    "auth/config/saml2.web.post.authchallengeheader.name":"com.backend.example.cloud.security.login",
    "auth/config/saml2.web.post.finish.endpoint.redirectparam":"finishEndpointParam",
    "auth/config/saml2.web.post.finish.endpoint.uri":"/SAMLAuthLauncher",
    "host":"example.backend.com",
    "protocol":"https"
]
```

can describe a multi-level data structure in which the different levels are separated by `/` in the key

Each level is an array of dictionaries and for convenience reasons the index is omitted in the notation. Hence `auth/type` is actually representing `auth[0]["type"]`

To inflate the dictionary and re-construct the multi-level data structure can be achieved by using the `inflate` function which is available as `Dictionary` extension 

```Swift
let result = dic.inflate()
```

For the example above you will receive the following result

```Swift
result: [String: Any] = [
    "host":"example.backend.com",
    "protocol":"https",
    "auth": [
        ["type": "saml2.web.post",
         "config":
            [
                [
                    "saml2.web.post.authchallengeheader.name": "com.backend.example.cloud.security.login",
                    "saml2.web.post.finish.endpoint.redirectparam" : "finishEndpointParam",
                    "saml2.web.post.finish.endpoint.uri": "/SAMLAuthLauncher"
                ]
            ]
        ]
    ]
]
```

## Limitations

- Index Notation is not (yet) supported

	```Swift
	let dic:[String: String] = [
		"auth/type":"saml2.web.post",
		"auth/config[0]/saml2.web.post.authchallengeheader.name":"com.backend.example.cloud.security.login",
		"auth/config[0]/saml2.web.post.finish.endpoint.redirectparam":"finishEndpointParam",
		"auth/config[0]/saml2.web.post.finish.endpoint.uri":"/SAMLAuthLauncher",
		"host":"example.backend.com",
		"protocol":"https"
	]
	let result = dic.inflate() // will behave unexpectedly 
	```
