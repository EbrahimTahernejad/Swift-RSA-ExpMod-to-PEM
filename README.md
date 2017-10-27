# Swift RSA Exp+Mod to PEM

Create RSA Public Key PEM from Modulus and Exponent value in Swift, without using any dependency.

This allows you to use the modulus/exponent values for validating signed value.

The original code is based on [this project](https://github.com/tracker1/node-rsa-pem-from-mod-exp)

EZ to use!

### hex
```RSAConverter.pemFrom(mod: yourMod, exp: yourExp)```

### base64
```RSAConverter.pemFrom(mod_b64: yourModBase64, exp_b64: yourExpBase64)```


The output would be like: 
```
MIIBCgKCAQEAniqcAxl7LclB0kE6q9AcAd8EE+0W6AsriR9Fs9T+6QVXl8uiCiAb
h/KCyy8X8C2bHsFpNBvwGTqMwHbqZqWBVUvYRtfCFcy3Xmertb09DnOBeWqKS418
1kss97JDO6G07QNbuLSWwkkO82CHD1kUmeF5/dof0Ra6bsRXqppdo86NzlgFud+E
2s5BM3XwewZVSpA69bwEiXaRDhrsg5mqeOm68VyxE8LQu+895kKsBnTvTueZTrXT
+HNaIveoYe8+Lb7b/mZYtlhrDK0i/8EDox85vxnzKZ7wNswqqcDg6vfC2911phST
Ph13jv2FIOkjO/WHhHEzRnS2VQqivqIbsQIDAQAB
```
