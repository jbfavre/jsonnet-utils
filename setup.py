from setuptools import setup, find_packages

setup(
    name='jsonnet_utils',
    version='0.1',
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        'Click',
        'jsonnet',
    ],
    entry_points='''
        [console_scripts]
        jsonnet-utils-grafana-convert=jsonnet_utils.cli:dashboard_convert
        jsonnet-utils-prometheus-convert=jsonnet_utils.cli:rule_convert
        jsonnet-utils-grafana-test=jsonnet_utils.cli:dashboard_test
    ''',
)
