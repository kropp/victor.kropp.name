{{ if $.Site.Data.events.talks.upcoming }}
<h4>Upcoming public appearances</h4>
{{ end }}
{{ range $.Site.Data.events.talks.upcoming }}
  <p>{{ (time .date).Format "January, 2" }} <a href="{{ .href }}"><strong>{{ .name }}</strong></a> <i class="flag flag-{{ .country }}"></i></p>
{{ end }}
