local grafana = import 'grafonnet/grafana.libsonnet';
{
dashboard:: {
  new(
    title='Prometheus 2.0 Stats',
    description='',
    tags=['prometheus'],
    refresh='1m',
    time_from='now-1h',
    uid='',
  ):: self + grafana.dashboard.new(
    title=title,
    description=description,
    tags=tags,
    refresh=refresh,
    time_from=time_from,
    uid=uid
  )
.addPanel(
  grafana.graphPanel.new(
    'Samples Appended',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(irate(prometheus_tsdb_head_samples_appended_total{job="prometheus"}[5m]))
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 0,
    h: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Scrape Duration',
    datasource='$datasource',
    span=null,
    format='s',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(5, max(scrape_duration_seconds) by (job))
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 6,
    h: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Memory Profile',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(process_resident_memory_bytes{job="prometheus"})
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      process_virtual_memory_bytes{job="prometheus"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 12,
    h: 0,
  }
)
.addPanel(
  grafana.singlestat.new(
    'WAL Corruptions',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      prometheus_tsdb_wal_corruptions_total{job="prometheus"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 18,
    h: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Active Appenders',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(prometheus_tsdb_head_active_appenders{job="prometheus"})
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum(process_open_fds{job="prometheus"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 0,
    h: 6,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Blocks Loaded',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      prometheus_tsdb_blocks_loaded{job="prometheus"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 6,
    h: 6,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Head Chunks',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      prometheus_tsdb_head_chunks{job="prometheus"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 12,
    h: 6,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Head Block GC Activity',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      prometheus_tsdb_head_gc_duration_seconds{job="prometheus",quantile="0.99"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      irate(prometheus_tsdb_head_gc_duration_seconds_count{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 6,
    w: 18,
    h: 6,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Compaction Activity',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      histogram_quantile(0.99, sum(rate(prometheus_tsdb_compaction_duration_bucket{job="prometheus"}[5m])) by (le))
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      irate(prometheus_tsdb_compactions_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      irate(prometheus_tsdb_compactions_failed_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      irate(prometheus_tsdb_compactions_triggered_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 8,
    w: 0,
    h: 12,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Reload Count',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      rate(prometheus_tsdb_reloads_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      rate(prometheus_tsdb_reloads_failures_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 8,
    w: 8,
    h: 12,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Query Durations',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      prometheus_engine_query_duration_seconds{job="prometheus", quantile="0.99"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 6,
    y: 8,
    w: 16,
    h: 12,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Rule Group Eval Duration',
    datasource='$datasource',
    span=null,
    format='s',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      max(prometheus_rule_group_duration_seconds{job="prometheus"}) by (quantile)
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 7,
    y: 12,
    w: 0,
    h: 18,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Rule Group Eval Activity',
    datasource='$datasource',
    span=null,
    format='short',
    stack='True',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      rate(prometheus_rule_group_iterations_missed_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      rate(prometheus_rule_group_iterations_total{job="prometheus"}[5m])
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 7,
    y: 12,
    w: 12,
    h: 18,
  }
)
}
}