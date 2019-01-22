<dl class="talks">
{{ range $.Site.Data.events.talks.upcoming }}
  <dt>{{ (time .date).Format "January, 2" }} <a href="{{ .href }}">{{ .name }}</a> <i class="flag flag-{{ .country }}"></i></dt>
  <dd><ul>
{{ range .talks }}
  <li>{{ .title }}</li>
{{ end }}
  </ul></dd>
{{ else }}

<p>No events planned at the moment.</p>

{{ end }}
</dl>
