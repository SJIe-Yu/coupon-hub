#!/usr/bin/env sh
set -eu

proxy="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-}}}}"

if [ -n "$proxy" ]; then
  authority="${proxy#*://}"
  authority="${authority#*@}"
  authority="${authority%%/*}"
  host="${authority%%:*}"
  port="${authority##*:}"

  if [ "$port" = "$authority" ]; then
    case "$proxy" in
      https://*) port=443 ;;
      *) port=80 ;;
    esac
  fi

  proxy_opts="-Dhttp.proxyHost=${host} -Dhttp.proxyPort=${port} -Dhttps.proxyHost=${host} -Dhttps.proxyPort=${port}"
  non_proxy="${NO_PROXY:-${no_proxy:-}}"
  non_proxy_hosts=""
  if [ -n "$non_proxy" ]; then
    non_proxy_hosts="$(printf '%s' "$non_proxy" | tr ',' '|')"
    proxy_opts="${proxy_opts} -Dhttp.nonProxyHosts=${non_proxy_hosts} -Dhttps.nonProxyHosts=${non_proxy_hosts}"
  fi

  mkdir -p "${HOME}/.m2"
  cat > "${HOME}/.m2/settings.xml" <<EOF
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">
  <proxies>
    <proxy>
      <id>coupon-hub-http-proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>${host}</host>
      <port>${port}</port>
      <nonProxyHosts>${non_proxy_hosts}</nonProxyHosts>
    </proxy>
    <proxy>
      <id>coupon-hub-https-proxy</id>
      <active>true</active>
      <protocol>https</protocol>
      <host>${host}</host>
      <port>${port}</port>
      <nonProxyHosts>${non_proxy_hosts}</nonProxyHosts>
    </proxy>
  </proxies>
</settings>
EOF

  export MAVEN_OPTS="${MAVEN_OPTS:-} ${proxy_opts}"
  exec ./mvnw --settings "${HOME}/.m2/settings.xml" "$@"
fi

exec ./mvnw "$@"
