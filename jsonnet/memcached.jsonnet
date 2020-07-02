local grafana = import 'grafonnet/grafana.libsonnet';
{
dashboard:: {
  new(
    title='Prometheus memcached',
    description='Prometheus dashboard for memcached servers',
    tags=['prometheus', 'memcached'],
    refresh='1m',
    time_from='now-1h',
    uid='6TAcjTCZk',
  ):: self + grafana.dashboard.new(
    title=title,
    description=description,
    tags=tags,
    refresh=refresh,
    time_from=time_from,
    uid=uid
  )
.addTemplate(
  grafana.template.new(
    name='job',
    datasource=datasource,
    includeAll=false,
    query='label_values(memcached_up,job)',
    refresh=0,
    sort=0,
  )
)
.addPanel(
  grafana.graphPanel.new(
    '% Hit ratio',
    datasource='$datasource',
    span=null,
    format='percentunit',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_commands_total{job="$job", status="miss"}) by (instance) / sum (memcached_commands_total{job="$job"}) by (instance)
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_commands_total{job="$job", status="miss"}) / sum (memcached_commands_total{job="$job"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 8,
    x: 0,
    y: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Connections',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_current_connections{job="$job"}) by (instance)
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 8,
    x: 8,
    y: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Get / Set ratio',
    datasource='$datasource',
    span=null,
    format='percentunit',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_commands_total{job="$job", command="set"}) / sum (memcached_commands_total{job="$job", command="get"})
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_commands_total{job="$job", command="set"}) by (instance) / sum (memcached_commands_total{job="$job", command="get"}) by (instance)
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 8,
    x: 16,
    y: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Commands',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(irate (memcached_commands_total{job="$job"}[$__interval])) by (command)
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 0,
    y: 7,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'evicts / reclaims',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(memcached_items_evicted_total{job="$job"})
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum(memcached_items_reclaimed_total{job="$job"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 12,
    y: 7,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Read / written bytes',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(irate(memcached_read_bytes_total{job="$job"}[$__interval]))
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum(irate(memcached_written_bytes_total{job="$job"}[$__interval]))
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 0,
    y: 14,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Total memory usage',
    datasource='$datasource',
    span=null,
    format='percentunit',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(memcached_current_bytes{job="$job"}) / sum(memcached_limit_bytes{job="$job"})
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum(memcached_current_bytes{job="$job"}) by (instance) / sum(memcached_limit_bytes{job="$job"}) by (instance)
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 12,
    y: 14,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Items in cache',
    datasource='$datasource',
    span=null,
    format='short',
    stack='True',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum (memcached_current_items{job="$job"}) by (instance)
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 24,
    x: 0,
    y: 21,
  }
)
}
}