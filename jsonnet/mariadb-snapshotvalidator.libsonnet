local grafana = import 'grafonnet/grafana.libsonnet';
{
dashboard:: {
  new(
    title='MariaDB - Snapshot Validator',
    description='',
    tags=[],
    refresh='3m',
    time_from='now-1h',
    uid='YCXUOI4iz',
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
    'namespace',
    'label_values(kube_cronjob_info{cronjob=~"^.*snapshot-validator$"},namespace)',
    'instance'
  )
)
.addTemplate(
  grafana.template.new(
    'job',
    'label_values(kube_cronjob_info{namespace="$namespace",cronjob=~"^.*snapshot-validator$"},cronjob)',
    'instance'
  )
)
.addRow(
  grafana.row.new(
    title='$job',
    height=null,
    collapse=false,
    repeat='job',
    showTitle=null,
    titleSize='h6'
  )
)
.addPanel(
  grafana.singlestat.new(
    'Last Run',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      time() - max(kube_job_status_start_time{namespace="$namespace",job_name=~"$job-[0-9]+"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 0,
    h: 1,
  }
)
.addPanel(
  grafana.singlestat.new(
    'STATUS',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace="$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_active{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 6,
    h: 1,
  }
)
.addPanel(
  grafana.singlestat.new(
    'SUCCEEDED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_succeeded{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 12,
    h: 1,
  }
)
.addPanel(
  grafana.singlestat.new(
    'FAILED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_failed{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) / topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job.*"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 16,
    h: 1,
  }
)
.addPanel(
  grafana.singlestat.new(
    'Duration',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      max(kube_job_status_completion_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) - max(kube_job_status_start_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) > 0
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 20,
    h: 1,
  }
)
.addRow(
  grafana.row.new(
    title='$job',
    height=null,
    collapse=false,
    repeat='None',
    showTitle=null,
    titleSize='h6'
  )
)
.addPanel(
  grafana.singlestat.new(
    'Last Run',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      time() - max(kube_job_status_start_time{namespace="$namespace",job_name=~"$job-[0-9]+"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 0,
    h: 5,
  }
)
.addPanel(
  grafana.singlestat.new(
    'STATUS',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace="$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_active{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 6,
    h: 5,
  }
)
.addPanel(
  grafana.singlestat.new(
    'SUCCEEDED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_succeeded{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 12,
    h: 5,
  }
)
.addPanel(
  grafana.singlestat.new(
    'FAILED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_failed{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) / topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job.*"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 16,
    h: 5,
  }
)
.addPanel(
  grafana.singlestat.new(
    'Duration',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      max(kube_job_status_completion_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) - max(kube_job_status_start_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) > 0
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 20,
    h: 5,
  }
)
.addRow(
  grafana.row.new(
    title='$job',
    height=null,
    collapse=false,
    repeat='None',
    showTitle=null,
    titleSize='h6'
  )
)
.addPanel(
  grafana.singlestat.new(
    'Last Run',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      time() - max(kube_job_status_start_time{namespace="$namespace",job_name=~"$job-[0-9]+"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 0,
    h: 9,
  }
)
.addPanel(
  grafana.singlestat.new(
    'STATUS',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace="$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_active{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 6,
    h: 9,
  }
)
.addPanel(
  grafana.singlestat.new(
    'SUCCEEDED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_succeeded{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 12,
    h: 9,
  }
)
.addPanel(
  grafana.singlestat.new(
    'FAILED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_failed{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) / topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job.*"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 16,
    h: 9,
  }
)
.addPanel(
  grafana.singlestat.new(
    'Duration',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      max(kube_job_status_completion_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) - max(kube_job_status_start_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) > 0
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 20,
    h: 9,
  }
)
.addRow(
  grafana.row.new(
    title='$job',
    height=null,
    collapse=false,
    repeat='None',
    showTitle=null,
    titleSize='h6'
  )
)
.addPanel(
  grafana.singlestat.new(
    'Last Run',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      time() - max(kube_job_status_start_time{namespace="$namespace",job_name=~"$job-[0-9]+"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 0,
    h: 13,
  }
)
.addPanel(
  grafana.singlestat.new(
    'STATUS',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace="$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_active{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 6,
    w: 6,
    h: 13,
  }
)
.addPanel(
  grafana.singlestat.new(
    'SUCCEEDED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_succeeded{namespace=~"$namespace",job_name=~"$job-[0-9]+"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 12,
    h: 13,
  }
)
.addPanel(
  grafana.singlestat.new(
    'FAILED',
    datasource='$datasource',
    span=null,
    format='none',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) * kube_job_status_failed{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) / topk(1,kube_job_created{namespace=~"$namespace",job_name=~"$job.*"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 16,
    h: 13,
  }
)
.addPanel(
  grafana.singlestat.new(
    'Duration',
    datasource='$datasource',
    span=null,
    format='s',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      max(kube_job_status_completion_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) - max(kube_job_status_start_time{namespace=~"$namespace",job_name=~"$job-[0-9]+"}) > 0
    |||,
    legendFormat='',
  )
)
, gridPos={
    x: 3,
    y: 4,
    w: 20,
    h: 13,
  }
)
}
}