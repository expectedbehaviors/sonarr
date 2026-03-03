{{- define "sonarrConfigXmlContent" -}}
{{- /*
  Sonarr config.xml content for ExternalSecret. Placeholders __API_KEY__, __POSTGRES_PASSWORD__
  are replaced in externalSecrets.yaml with ESO v2 template syntax.
  Postgres host/user/db come from .Values.externalSecrets.configXml (Helm).
*/ -}}
{{- $configXmlValues := .Values.externalSecrets.configXml | default dict }}
{{- $configOptions := $configXmlValues.options | default dict }}
{{- $postgresConfig := $configXmlValues.postgres | default dict }}
{{- $databaseMode := lower ($configXmlValues.database | default ($postgresConfig.method | default "sqlite")) }}
{{- $postgresqlBlockEnabled := ne $databaseMode "sqlite" }}
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
  {{- if $postgresqlBlockEnabled }}
  {{- $postgresDefaultHost := printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace }}
  {{- if eq $databaseMode "operator" }}
    {{- $postgresDefaultHost = printf "%s-rw.%s.svc.cluster.local" .Values.postgresqlOperator.clusterName .Release.Namespace }}
  {{- else if eq $databaseMode "external" }}
    {{- $postgresDefaultHost = required "externalSecrets.configXml.postgres.host is required when database=external" $postgresConfig.host }}
  {{- end }}
  <PostgresUser>{{ $postgresConfig.user | default "postgres" }}</PostgresUser>
  <PostgresPassword>__POSTGRES_PASSWORD__</PostgresPassword>
  <PostgresPort>{{ $postgresConfig.port | default "5432" }}</PostgresPort>
  <PostgresHost>{{ $postgresConfig.host | default $postgresDefaultHost }}</PostgresHost>
  <PostgresMainDb>{{ $postgresConfig.mainDb | default "sonarr-main" }}</PostgresMainDb>
  <PostgresLogDb>{{ $postgresConfig.logDb | default "sonarr-log" }}</PostgresLogDb>
  {{- end }}
  <ConsoleLogLevel>{{ $configOptions.consoleLogLevel | default "info" }}</ConsoleLogLevel>
{{- range $optionName, $optionValue := $configXmlValues.additionalOptions }}
  <{{ $optionName }}>{{ $optionValue }}</{{ $optionName }}>
{{- end }}
</Config>
{{- end -}}
