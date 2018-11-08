{% for pkg in pillar.get('pkgs', []) %}
{{ pkg }}:
  pkg.installed
{% endfor %}

{% for pkg in pillar.get('pip-pkgs', []) %}
{{ pkg }}:
  pip.installed:
    - require:
      - pkg: python-pip
{% endfor %}

/srv/gitlab/config/:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
    - dir_mode: 755

/srv/postgres/saltstack_database.sql:
  file.managed:
    - source: salt://os_requirements/saltstack_database.sql
    - makedirs: True

