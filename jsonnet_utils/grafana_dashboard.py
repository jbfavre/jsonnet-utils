import json
import re
import os
import glob
import _jsonnet
import logging
import subprocess
from .prometheus_rule import search_prometheus_metrics, metrics_rules

from .utils import parse_yaml

logging.basicConfig(
    format="%(asctime)s [%(levelname)-5.5s]  %(message)s",
    level=logging.INFO,
    handlers=[logging.StreamHandler()],
)

GRAFONNET_INCLUDES = """local grafana = import 'grafonnet/grafana.libsonnet';"""

GRAFONNET_HEADER = """dashboard:: {{
  new(
    title='{}',
    description='{}',
    tags={},
    refresh='{}',
    time_from='{}',
    uid='{}',
  ):: self + grafana.dashboard.new(
    title=title,
    description=description,
    tags=tags,
    refresh=refresh,
    time_from=time_from,
    uid=uid
  )"""

GRAFONNET_GRAPH_PANEL = """.addPanel(
  grafana.graphPanel.new(
    '{}',
    datasource='$datasource',
    span={},
    format='{}',
    stack='{}',
    min=0,
  )"""

GRAFONNET_SINGLESTAT_PANEL = """.addPanel(
  grafana.singlestat.new(
    '{}',
    datasource='$datasource',
    span={},
    format='{}',
    valueName='current',
  )"""

GRAFONNET_GRIDPOS = """, gridPos={{
    h: {},
    w: {},
    x: {},
    y: {},
  }}
)"""

GRAFONNET_ROW = """.addRow(
  grafana.row.new(
    title='{}',
    height={},
    collapse={},
    repeat='{}',
    showTitle={},
    titleSize='{}'
  )
)"""

GRAFONNET_PROMETHEUS_TARGET = """.addTarget(
  grafana.prometheus.target(
    |||
      {}
    |||,
    legendFormat='',
  )
)"""

GRAFONNET_TEMPLATE = """.addTemplate(
  grafana.template.new(
    '{}',
    '{}',
    'instance'
  )
)"""

def extract_panel(panel):
    panel_lines=[]
    if panel["type"] == "row":
        panel_lines.append(
            GRAFONNET_ROW.format(
                "Dashboard Row" if "title" not in panel else panel["title"],
                "null" if "height" not in panel else panel["height"],
                "false" if "collapse" not in panel else panel["collapse"],
                "null" if "repeat" not in panel else panel["repeat"],
                "null" if "showTitle" not in panel else panel["showTitle"],
                "h6" if "titleSize" not in panel else panel["titleSize"]
            )
        )
    if panel["type"] == "singlestat":
        panel_lines.append(
            GRAFONNET_SINGLESTAT_PANEL.format(
                panel["title"],
                "null" if "span" not in panel else panel["span"],
                panel["format"]
            )
        )
    if panel["type"] == "graph":
        panel_lines.append(
            GRAFONNET_GRAPH_PANEL.format(
                panel["title"],
                "null" if "span" not in panel else panel["span"],
                panel["yaxes"][0]["format"],
                str(panel["stack"])
            )
        )
    for target in panel.get("targets", []):
        if "expr" in target:
            panel_lines.append(
                GRAFONNET_PROMETHEUS_TARGET.format(target["expr"])
            )
    gridPos = ""
    if panel["gridPos"] and panel["type"] != "row":
        panel_lines.append(
            GRAFONNET_GRIDPOS.format(
                panel['gridPos']['h'],
                panel['gridPos']['w'],
                panel['gridPos']['x'],
                panel['gridPos']['y']
            )
        )
    return "\n".join(panel_lines)

def convert_dashboard_jsonnet(dashboard, format, source_path, build_path):
    dashboard_lines = []
    dashboard_lines.append(GRAFONNET_INCLUDES)
    dashboard_lines.append("{")
    dashboard_lines.append(
        GRAFONNET_HEADER.format(
            dashboard.get("title", "Dashboard title"),
            dashboard.get("description", ""),
            dashboard.get("tags", "[]"),
            dashboard.get("refresh", "1m"),
            dashboard.get("time_from", "now-1h"),
            dashboard.get("uid", ""),
        )
    )
    for variable in dashboard.get("templating", {}).get("list", []):
        if variable["type"] == "query":
            dashboard_lines.append(
                GRAFONNET_TEMPLATE.format(
                    variable["name"],
                    variable["query"]
                )
            )
    for panel in dashboard.get("panels", []):
        panel_str = extract_panel(panel)
        dashboard_lines.append(panel_str)

    dashboard_lines.append("}\n}")
    dashboard_str = "\n".join(dashboard_lines)

    if build_path == "":
        print("JSONNET:\n{}".format(dashboard_str))
        print("JSON:\n{}".format(_jsonnet.evaluate_snippet("snippet", dashboard_str)))
    else:
        build_file = (
            build_path + "/" + dashboard["_filename"].replace(".json", ".jsonnet")
        )
        with open(build_file, "w") as the_file:
            the_file.write(dashboard_str)
        logging.info(
            "Converted dashboard `{}/{}` to `{}` ({} format)".format(
                source_path, dashboard["_filename"], build_file, format
            )
        )
        # output = (
        #     subprocess.Popen(
        #         "jsonnetfmt -n 2 -i "
        #         + build_file,
        #         shell=True,
        #         stdout=subprocess.PIPE,
        #         stderr=subprocess.STDOUT,
        #     )
        #     .stdout.read()
        #     .decode("utf-8")
        # )
        # if "ERROR" in output:
        #     logging.info(
        #         "Error `{}` reformatting dashboard `{}/{}` to `{}`".format(
        #             output, source_path, dashboard["_filename"], build_file
        #         )
        #     )
        # else:
        #     logging.info(
        #         "Reformatted dashboard `{}/{}` to `{}` ({} format)".format(
        #             source_path, dashboard["_filename"], build_file, format
        #         )
        #     )

    return dashboard_str


def parse_dashboard(board_file):
    with open(board_file) as f:
        dashboard = json.load(f)
    panels = []
    for panel in dashboard["panels"]:
        panels.append(panel)
    dashboard["_filename"] = os.path.basename(board_file)
    dashboard["_panels"] = panels
    return dashboard


def convert_dashboards(source_path, build_path, format, layout):
    board_files = glob.glob("{}/*.json".format(source_path))
    for board_file in board_files:
        dashboard = parse_dashboard(board_file)
        convert_dashboard_jsonnet(dashboard, format, source_path, build_path)

    if len(board_files) == 0:
        logging.error("No dashboards found at given path!")


def test_dashboards(path):
    board_files = glob.glob("{}/*.json".format(path))
    for board_file in board_files:
        dashboard = parse_dashboard(board_file)
        logging.info("Testing dashboard `{}` ... OK".format(dashboard["_filename"]))
    if len(board_files) == 0:
        logging.error("No dashboards found at given path!")

