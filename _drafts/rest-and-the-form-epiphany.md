---
layout: post
title: REST and the FORM epiphany
---

HTML `<form>` tags only have two recognized values for their `method` attribute:
`"get"` or `"post"`.
[See?](https://www.w3.org/TR/REC-html40/interact/forms.html#adef-method)
The W3C even says so.
But HTTP has 4 common request methods:
`GET`, `POST`, `PUT`, and `DELETE,`
and a handful of others
(`HEAD`, `CONNECT`, `OPTIONS`, `TRACE`).
[See?](https://tools.ietf.org/html/rfc7231#section-4.3)
The IETF even says so.

How come I can't write a `<form>` that will submit a `PUT` or a `DELETE`?
Seems weird, right?

Consider for a moment the RESTful architectural style.
(I know, right?
__Super__ pretensious.)
Every URL
(not every Rails route, but every URL)
is the identifier for a resource.
And there's a limited vocabularity of verbs that apply to every resource.
("get", "put", "delete" and "post").

Get and put are supposed to be complimentary.
Roughly speaking, if I `PUT` to `/resource/123`,
and nothing else happens in between,
when I `GET /resource/123` I should get whatever I put there before.
You know, like a key-value store.
But modulo whatever logic and contraints the server puts on
`/resource/123`
