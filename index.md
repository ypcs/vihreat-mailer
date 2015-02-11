---
layout: default
---

<h1>Posts</h1>
<ul>
{% for p in site.posts %}
    <li>{{ p.date }} <a href="{{ p.url }}">{{ p.title }}</a></li>
{% endfor %}
</ul>
