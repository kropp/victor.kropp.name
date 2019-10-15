---
title: "A curios case of (sometimes) failing HTTPS connection"
date: "2019-10-15T19:11:09+02:00"
description: With some tips on how to check HTTPS connection with OpenSSL
twitter_card: summary_large_image
image: /blog/img/2019/secure-connection-victor.kropp.name.png
tags:
    - https
    - openssl
    - encryption
    - privacy
---

Few days ago I stumbled upon an interesting bug with some HTTPS site, which was working correctly on some computers and threw Insecure connection error on the other. After resolving the issue (on the server side), I decided to write down the things I learned. Hope it will be useful and could save you some time debugging SSL issues.

### HTTPS

According to Firefox Telemetry [nearly 70% of web pages](https://docs.telemetry.mozilla.org/datasets/other/ssl/reference.html) are now loaded over secure and encrypted HTTPS connection. My website is not an exclusion, check the green padlock icon in the address bar.

{{< figure src="/blog/img/2019/secure-connection-victor.kropp.name.png" width="500" height="275" attr="victor.kropp.name" >}}

Let’s define what “secure” and “encrypted” mean and why I use both words here.

### Encrypted traffic

Encryption hides the contents of your communication from those who are able to spy on the raw data you are exchanging with the server. For example, you may watch all the data in your local network at home or in the office. If the data were in plain text, you’ll be able to see what sites your coworkers visit, their passwords, etc.

To prevent this when browser and server establish a connection they set up a session key using [Diffie-Hellman key exchange algorithm](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange). With this only two end parties know how to decrypt the traffic.

### Man in the middle

Unfortunately, encryption is not enough to be sure your communication is secure. It doesn’t guarantee that the far end is the one you think it is. Instead, it could be a malicious third party in the middle, which intercepts your connection and pretend it is a server. It can then pass all the traffic between you and a real server through. Even if the traffic will be encrypted on both legs, it still will be visible in plain text to an adversary.

HTTPS requires a certificate to prove that the web server you are connected to is indeed the one you wanted. How one can verify the certificate is valid? You can’t check each individual certificate, it is simply impossible.

### Certificate Authorities

Instead, you may choose to trust a few well-known organizations called Certificate Authorities (CA). They issue certificates to individual websites and digitally sign them with their certificates. Actually root certificates of around 150 CAs are bundled in your operating system and browser. But using this certificates on a daily basis would be to vulnerable (if a malicious user gets access to a certificate ultimately trusted by all computers in the world it would be a disaster). So CA issue intermediate certificates and use them to sign others.

Let’s check for example the certificate chain on this website:

<pre class="shell"><code><b>$</b> openssl s_client -connect victor.kropp.name:443</code></pre>
<pre class="highlight"><code>CONNECTED(00000003)
depth=2 O = Digital Signature Trust Co., CN = DST Root CA X3
verify return:1
depth=1 C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
verify return:1
depth=0 CN = victor.kropp.name
verify return:1
---
Certificate chain
 0 s:CN = victor.kropp.name
   i:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
 1 s:C = US, O = Let's Encrypt, CN = Let's Encrypt Authority X3
   i:O = Digital Signature Trust Co., CN = DST Root CA X3
---
</code></pre>

So the chain of trust is **DST Root CA X3** → **Let's Encrypt Authority X3** → **victor.kropp.name**

### Intermediate certificate

The issue I faced in the first place was related to these intermediate certificates. The website I tried to access due to [misconfiguration](https://nginx.org/en/docs/http/configuring_https_servers.html#chains) only provided its own certificate. Even though it was valid, and I had correct root certificate installed, it was not possible to build a valid chain of trust between them, because intermediate certificate was missing.

According to [RFC 5246 7.4.2](https://tools.ietf.org/html/rfc5246#section-7.4.2) the server MUST send the whole certificate chain. It may only omit root certificate, because the client should have one already.

>   The server MUST send a Certificate message whenever the agreed-upon key exchange method uses certificates for authentication…
>
>   Meaning of this message:
>
>   This message conveys the server's certificate chain to the client.
>
>   Structure of this message:
> <p></p>
>
>     opaque ASN.1Cert<1..2^24-1>;
>
>     struct {
>         ASN.1Cert certificate_list<0..2^24-1>;
>     } Certificate;

>     certificate_list
>
>   This is a sequence (chain) of certificates.  The sender's
>   certificate MUST come first in the list.  Each following
>   certificate MUST directly certify the one preceding it.  Because
>   certificate validation requires that root keys be distributed
>   independently, the self-signed certificate that specifies the root
>   certificate authority MAY be omitted from the chain, under the
>   assumption that the remote end must already possess it in order to
>   validate it in any case.

There is an example of such a misconfigured server at [incomplete-chain.badssl.com](https://incomplete-chain.badssl.com/):

<pre class="shell"><code><b>$</b> openssl s_client -connect incomplete-chain.badssl.com:443</code></pre>
<pre class="highlight"><code>CONNECTED(00000003)
depth=0 C = US, ST = California, L = Walnut Creek, O = Lucas Garron, CN = *.badssl.com
<b>verify error:num=20:unable to get local issuer certificate</b>
verify return:1
depth=0 C = US, ST = California, L = Walnut Creek, O = Lucas Garron, CN = *.badssl.com
<b>verify error:num=21:unable to get local issuer certificate</b>
verify return:1
---
Certificate chain
 0 s:C = US, ST = California, L = Walnut Creek, O = Lucas Garron, CN = *.badssl.com
   i:C = US, O = DigiCert Inc, CN = DigiCert SHA2 Secure Server CA
---
</code></pre>

This server only provides its certificate for `*.badssl.com`, which is signed by **DigiCert SHA2 Secure Server CA**. Compare to the correct full chain at [badssl.com](https://badssl.com/):

<pre class="shell"><code><b>$</b> openssl s_client -connect badssl.com:443</code></pre>
<pre class="highlight"><code>CONNECTED(00000003)
depth=2 C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert Global Root CA
verify return:1
depth=1 C = US, O = DigiCert Inc, CN = DigiCert SHA2 Secure Server CA
verify return:1
depth=0 C = US, ST = California, L = Walnut Creek, O = Lucas Garron, CN = *.badssl.com
verify return:1
---
Certificate chain
 0 s:C = US, ST = California, L = Walnut Creek, O = Lucas Garron, CN = *.badssl.com
   i:C = US, O = DigiCert Inc, CN = DigiCert SHA2 Secure Server CA
 1 s:C = US, O = DigiCert Inc, CN = DigiCert SHA2 Secure Server CA
   i:C = US, O = DigiCert Inc, OU = www.digicert.com, CN = DigiCert Global Root CA
---
</code></pre>

I do have **DigiCert Global Root CA** in the trusted roots, but without having intermediate certificate I can’t check the validity of **DigiCert SHA2 Secure Server CA** signature on badssl.com’s certificate.

But why did it work on some machines? The answer is

### Cache

To speed up certificate validation and to circumvent such errors, browsers cache intermediate certificates. So if I ever visited a site with certificate issued by DigiCert chances are their intermediate certificate is my browser’s cache ([cert9.db](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Reference/NSS_tools_:_certutil) in your Firefox profile directory, for example). That’s why my connection to this site is secure even when it isn’t properly configured.

{{< figure src="/blog/img/2019/secure-connection-badssl.png" width="453" height="245" attr="incomplete-chain.badssl.com" attrlink="https://incomplete-chain.badssl.com/" >}}

But I, for example, accessing this site from code and from browser, I don’t usually have a cache. And connection will fail for security reasons.

### Do not disable validation!

Unfortunately when googling on failed SSL connection, one of the most popular answers is to disable validation. Please don’t do this, even for testing purposes. It is easy to forget to enable it and this effectively disables all protection your browser was building for years to defend your right on private communication.

The second most popular answer was to install newer root certificate. If you are using some legacy systems which weren’t updated for years, this might be a root cause of the problem. Not in this case though. Unfortunately, I spend an hour checking root certificates inside Docker container to only find out they are absolutely OK.

PS. If you ever wondered how exactly HTTPS connection is established, here is your complete and detailed [illustrated guide](https://tls13.ulfheim.net/).
