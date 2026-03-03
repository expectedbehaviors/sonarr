{{- define "sonarr_config_xml_content" -}}
{{- /*
  Sonarr config.xml content for ExternalSecret. Placeholders __API_KEY__, __POSTGRES_PASSWORD__
  are replaced in externalSecrets.yaml with ESO v2 template syntax.
  Postgres host/user/db come from .Values.externalSecrets.configXml (Helm).
*/ -}}
{{- $e := .Values.externalSecrets.configXml | default dict }}
{{- $o := $e.options | default dict }}
<Config>
  <LogLevel>{{ $o.logLevel | default "Info" }}</LogLevel>
  <Port>{{ $o.port | default "8989" }}</Port>
  <UrlBase>{{ $o.urlBase | default "" }}</UrlBase>
  <BindAddress>{{ $o.bindAddress | default "*" }}</BindAddress>
  <SslPort>{{ $o.sslPort | default "9898" }}</SslPort>
  <EnableSsl>{{ $o.enableSsl | default "False" }}</EnableSsl>
  <ApiKey>__API_KEY__</ApiKey>
  <AuthenticationMethod>{{ $o.authenticationMethod | default "Basic" }}</AuthenticationMethod>
  <Branch>{{ $o.branch | default "develop" }}</Branch>
  <LaunchBrowser>{{ $o.launchBrowser | default "False" }}</LaunchBrowser>
  <UpdateMechanism>{{ $o.updateMechanism | default "Docker" }}</UpdateMechanism>
  <AnalyticsEnabled>{{ $o.analyticsEnabled | default "False" }}</AnalyticsEnabled>
  <UpdateAutomatically>{{ $o.updateAutomatically | default "True" }}</UpdateAutomatically>
  <InstanceName>{{ $o.instanceName | default "Sonarr" }}</InstanceName>
  <SslCertPath>{{ $o.sslCertPath | default "" }}</SslCertPath>
  <SslCertPassword>{{ $o.sslCertPassword | default "" }}</SslCertPassword>
  <AuthenticationRequired>{{ $o.authenticationRequired | default "DisabledForLocalAddresses" }}</AuthenticationRequired>
  <Theme>{{ $o.theme | default "dark" }}</Theme>
  <PostgresUser>{{ $e.postgresUser | default "postgres" }}</PostgresUser>
  <PostgresPassword>__POSTGRES_PASSWORD__</PostgresPassword>
  <PostgresPort>{{ $e.postgresPort | default "5432" }}</PostgresPort>
  <PostgresHost>{{ $e.postgresHost | default "postgresql-rw.postgresql.svc.cluster.local" }}</PostgresHost>
  <PostgresMainDb>{{ $e.postgresMainDb | default "sonarr-main" }}</PostgresMainDb>
  <PostgresLogDb>{{ $e.postgresLogDb | default "sonarr-log" }}</PostgresLogDb>
  <ConsoleLogLevel>{{ $o.consoleLogLevel | default "info" }}</ConsoleLogLevel>
{{- range $k, $v := $e.additionalOptions }}
  <{{ $k }}>{{ $v }}</{{ $k }}>
{{- end }}
</Config>
{{- end -}}
