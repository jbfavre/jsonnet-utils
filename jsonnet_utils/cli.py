#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import click
import logging
from .grafana_dashboard import convert_dashboards, test_dashboards
from .prometheus_rule import convert_rules

logging.basicConfig(
    format="%(asctime)s [%(levelname)-5.5s]  %(message)s",
    level=logging.INFO,
    handlers=[
        logging.StreamHandler()
    ])


@click.command()
@click.option('--source-path', default='./source', help='Path to search for the source JSON dashboards.')
@click.option('--build-path', default='', help='Path to save converted JSONNET dashboards, none to print to console.')
@click.option('--format', default='grafonnet', help='Format of the dashboard: `grafonnet` or `grafana-builder`.')
@click.option('--layout', default='rows',
              help='Format of the dashboard: `normal` (scheme 14) , `grid` (scheme 16).')
def dashboard_convert(source_path, build_path, format, layout):
    """Convert JSON dashboards to JSONNET format."""
    logging.info(
        'Searching path `{}` for JSON dashboards to convert ...'.format(source_path))
    convert_dashboards(source_path, build_path, format, layout)


@click.command()
@click.option('--path', default='./data', help='Path to search for the source JSON dashboards.')
@click.option('--scheme', default='16', help='Scheme version of the dashboard: `16` is the current.')
@click.option('--layout', default='rows',
              help='Format of the dashboard: `normal` (scheme 14) , `grid` (scheme 16).')
def dashboard_test(path, scheme, layout):
    """Test JSONNET formatted dashboards."""
    logging.info(
        'Searching path `{}` for JSON dashboards to test ...'.format(path))
    test_dashboards(path)

@click.command()
@click.option('--source-path', default='./source', help='Path to search for the source YAML rule files.')
@click.option('--build-path', default='', help='Path to save converted JSONNET rules, none to print to console.')
def rule_convert(source_path, build_path):
    """Convert Prometheus rule definitions to JSONNET format."""
    logging.info(
        'Searching path `{}` for YAML rule definitions to convert ...'.format(source_path))
    convert_rules(source_path, build_path)
