<dl class="talks">
{{ range $.Site.Data.events.talks.past }}
  <dt>{{ (time .date).Format "January 2006" }} {{ if .href }}<a href="{{ .href }}">{{ .name }}</a>{{ else }}{{ .name }}{{ end }} <i class="flag flag-{{ .country }}"></i></dt>
  <dd><ul>
{{ range .talks }}
  <li>{{ .title }}{{ if .slides }} (<a href="{{ .slides }}">slides</a>){{ end }}{{ if .code }} (<a href="{{ .code }}">code</a>){{ end }}{{ if .youtube }}
<div style="position: relative; padding: 30px 0; height: 360px; width: 640px; overflow: hidden;">
<iframe src="//www.youtube.com/embed/{{ .youtube }}" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" allowfullscreen frameborder="0" title="{{ .title }}"></iframe>
</div>
{{ end }}</li>
{{ end }}
  </ul></dd>
{{ else }}

<dt>No events planned at the moment.</dt>

{{ end }}
</dl>
