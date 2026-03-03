{{- define "sonarr_config_xml_content" -}}
{{- /*
  Sonarr config.xml content for ExternalSecret. Placeholders __API_KEY__, __POSTGRES_PASSWORD__
  are replaced in externalSecrets.yaml with ESO v2 template syntax.
  Postgres host/user/db come from .Values.externalSecrets.configXml (Helm).
*/ -}}
{{- $configXmlValues := .Values.externalSecrets.configXml | default dict }}
{{- $configOptions := $configXmlValues.options | default dict }}
{{- $databaseMode := lower ($configXmlValues.databaseMode | default "auto") }}
{{- $bitnamiPostgresqlEnabled := .Values.postgresql.enabled | default false }}
{{- $postgresqlOperatorEnabled := .Values.postgresqlOperator.enabled | default false }}
{{- $postgresHostOverride := $configXmlValues.postgresHost | default "" }}
{{- $managedPostgresqlConfigured := or $bitnamiPostgresqlEnabled $postgresqlOperatorEnabled }}
{{- $autoModeUsesPostgresql := or $managedPostgresqlConfigured (ne $postgresHostOverride "") }}
{{- $postgresqlBlockEnabled := false }}
{{- if eq $databaseMode "sqlite" }}
  {{- $postgresqlBlockEnabled = false }}
{{- else if or (eq $databaseMode "postgres") (eq $databaseMode "external-postgres") (eq $databaseMode "external") }}
  {{- $postgresqlBlockEnabled = true }}
{{- else }}
  {{- $postgresqlBlockEnabled = $autoModeUsesPostgresql }}
{{- end }}
<Config>
  <LogLevel>{{ $configOptions.logLevel | default "Info" }}</LogLevel>
  <Port>{{ $configOptions.port | default "8989" }}</Port>
  <UrlBase>{{ $configOptions.urlBase | default "" }}</UrlBase>
  <BindAddress>{{ $configOptions.bindAddress | default "*" }}</BindAddress>
  <SslPort>{{ $configOptions.sslPort | default "9898" }}</SslPort>
  <EnableSsl>{{ $configOptions.enableSsl | default "False" }}</EnableSsl>
  <ApiKey>__API_KEY__</ApiKey>
  <AuthenticationMethod>{{ $configOptions.authenticationMethod | default "Basic" }}</AuthenticationMethod>
  <Branch>{{ $configOptions.branch | default "develop" }}</Branch>
  <LaunchBrowser>{{ $configOptions.launchBrowser | default "False" }}</LaunchBrowser>
  <UpdateMechanism>{{ $configOptions.updateMechanism | default "Docker" }}</UpdateMechanism>
  <AnalyticsEnabled>{{ $configOptions.analyticsEnabled | default "False" }}</AnalyticsEnabled>
  <UpdateAutomatically>{{ $configOptions.updateAutomatically | default "True" }}</UpdateAutomatically>
  <InstanceName>{{ $configOptions.instanceName | default "Sonarr" }}</InstanceName>
  <SslCertPath>{{ $configOptions.sslCertPath | default "" }}</SslCertPath>
  <SslCertPassword>{{ $configOptions.sslCertPassword | default "" }}</SslCertPassword>
  <AuthenticationRequired>{{ $configOptions.authenticationRequired | default "DisabledForLocalAddresses" }}</AuthenticationRequired>
  <Theme>{{ $configOptions.theme | default "dark" }}</Theme>
  {{- $postgresDefaultHost := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- if $postgresqlOperatorEnabled }}
    {{- $postgresDefaultHost = printf "%s-rw.%s.svc.cluster.local" .Values.postgresqlOperator.clusterName .Release.Namespace }}
  {{- end }}
  {{- if $postgresqlBlockEnabled }}
  <PostgresUser>{{ $configXmlValues.postgresUser | default "postgres" }}</PostgresUser>
  <PostgresPassword>__POSTGRES_PASSWORD__</PostgresPassword>
  <PostgresPort>{{ $configXmlValues.postgresPort | default "5432" }}</PostgresPort>
  <PostgresHost>{{ $configXmlValues.postgresHost | default $postgresDefaultHost }}</PostgresHost>
  <PostgresMainDb>{{ $configXmlValues.postgresMainDb | default "sonarr-main" }}</PostgresMainDb>
  <PostgresLogDb>{{ $configXmlValues.postgresLogDb | default "sonarr-log" }}</PostgresLogDb>
  {{- end }}
  <ConsoleLogLevel>{{ $configOptions.consoleLogLevel | default "info" }}</ConsoleLogLevel>
{{- range $k, $v := $configXmlValues.additionalOptions }}
  <{{ $k }}>{{ $v }}</{{ $k }}>
{{- end }}
</Config>
{{- end -}}
