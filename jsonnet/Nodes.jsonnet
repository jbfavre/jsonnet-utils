local grafana = import 'grafonnet/grafana.libsonnet';
{
dashboard:: {
  new(
    title='Nodes',
    description='',
    tags=[],
    refresh='',
    time_from='now-1h',
    uid='fa49a4706d07a042595b664c87fb33ea',
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
    name='instance',
    datasource=datasource,
    includeAll=false,
    query='label_values(node_exporter_build_info{job="node-exporter"}, instance)',
    refresh=2,
    sort=0,
  )
)
.addPanel(
  grafana.graphPanel.new(
    'CPU Usage',
    datasource='$datasource',
    span=null,
    format='percentunit',
    stack='True',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (
  (1 - rate(node_cpu_seconds_total{job="node-exporter", mode="idle", instance="$instance"}[$__interval]))
/ ignoring(cpu) group_left
  count without (cpu)( node_cpu_seconds_total{job="node-exporter", mode="idle", instance="$instance"})
)

    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 0,
    y: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Load Average',
    datasource='$datasource',
    span=null,
    format='short',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      node_load1{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      node_load5{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      node_load15{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      count(node_cpu_seconds_total{job="node-exporter", instance="$instance", mode="idle"})
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 12,
    y: 0,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Memory Usage',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='True',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      (
  node_memory_MemTotal_bytes{job="node-exporter", instance="$instance"}
-
  node_memory_MemFree_bytes{job="node-exporter", instance="$instance"}
-
  node_memory_Buffers_bytes{job="node-exporter", instance="$instance"}
-
  node_memory_Cached_bytes{job="node-exporter", instance="$instance"}
)

    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      node_memory_Buffers_bytes{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      node_memory_Cached_bytes{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      node_memory_MemFree_bytes{job="node-exporter", instance="$instance"}
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 18,
    x: 0,
    y: 7,
  }
)
.addPanel(
  grafana.singlestat.new(
    'Memory Usage',
    datasource='$datasource',
    span=null,
    format='percent',
    valueName='current',
  )
.addTarget(
  grafana.prometheus.target(
    |||
      100 -
(
  node_memory_MemAvailable_bytes{job="node-exporter", instance="$instance"}
/
  node_memory_MemTotal_bytes{job="node-exporter", instance="$instance"}
* 100
)

    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 6,
    x: 18,
    y: 7,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Disk I/O',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      rate(node_disk_read_bytes_total{job="node-exporter", instance="$instance", device=~"nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+"}[$__interval])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      rate(node_disk_written_bytes_total{job="node-exporter", instance="$instance", device=~"nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+"}[$__interval])
    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      rate(node_disk_io_time_seconds_total{job="node-exporter", instance="$instance", device=~"nvme.+|rbd.+|sd.+|vd.+|xvd.+|dm-.+|dasd.+"}[$__interval])
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
    'Disk Space Usage',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='True',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      sum(
  max by (device) (
    node_filesystem_size_bytes{job="node-exporter", instance="$instance", fstype!=""}
  -
    node_filesystem_avail_bytes{job="node-exporter", instance="$instance", fstype!=""}
  )
)

    |||,
    legendFormat='',
  )
)
.addTarget(
  grafana.prometheus.target(
    |||
      sum(
  max by (device) (
    node_filesystem_avail_bytes{job="node-exporter", instance="$instance", fstype!=""}
  )
)

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
    'Network Received',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      rate(node_network_receive_bytes_total{job="node-exporter", instance="$instance", device!="lo"}[$__interval])
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 0,
    y: 21,
  }
)
.addPanel(
  grafana.graphPanel.new(
    'Network Transmitted',
    datasource='$datasource',
    span=null,
    format='bytes',
    stack='False',
    min=0,
  )
.addTarget(
  grafana.prometheus.target(
    |||
      rate(node_network_transmit_bytes_total{job="node-exporter", instance="$instance", device!="lo"}[$__interval])
    |||,
    legendFormat='',
  )
)
, gridPos={
    h: 7,
    w: 12,
    x: 12,
    y: 21,
  }
)
}
}