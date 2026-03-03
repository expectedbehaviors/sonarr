{{- define "sonarr_config_xml_content" -}}
{{- /*
  Sonarr config.xml content for ExternalSecret. Placeholders __API_KEY__, __POSTGRES_PASSWORD__
  are replaced in externalSecrets.yaml with ESO v2 template syntax.
  Postgres host/user/db come from .Values.externalSecrets.configXml (Helm).
*/ -}}
{{- $e := .Values.externalSecrets.configXml | default dict }}
<Config>
  <LogLevel>Info</LogLevel>
  <Port>8989</Port>
  <UrlBase></UrlBase>
  <BindAddress>*</BindAddress>
  <SslPort>9898</SslPort>
  <EnableSsl>False</EnableSsl>
  <ApiKey>__API_KEY__</ApiKey>
  <AuthenticationMethod>Basic</AuthenticationMethod>
  <Branch>develop</Branch>
  <LaunchBrowser>False</LaunchBrowser>
  <UpdateMechanism>Docker</UpdateMechanism>
  <AnalyticsEnabled>False</AnalyticsEnabled>
  <UpdateAutomatically>True</UpdateAutomatically>
  <InstanceName>Sonarr</InstanceName>
  <SslCertPath></SslCertPath>
  <SslCertPassword></SslCertPassword>
  <AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>
  <Theme>dark</Theme>
  <PostgresUser>{{ $e.postgresUser | default "postgres" }}</PostgresUser>
  <PostgresPassword>__POSTGRES_PASSWORD__</PostgresPassword>
  <PostgresPort>{{ $e.postgresPort | default "5432" }}</PostgresPort>
  <PostgresHost>{{ $e.postgresHost | default "postgresql-rw.postgresql.svc.cluster.local" }}</PostgresHost>
  <PostgresMainDb>{{ $e.postgresMainDb | default "sonarr-main" }}</PostgresMainDb>
  <PostgresLogDb>{{ $e.postgresLogDb | default "sonarr-log" }}</PostgresLogDb>
  <ConsoleLogLevel>info</ConsoleLogLevel>
</Config>
{{- end -}}
