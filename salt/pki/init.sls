human_friendly_state_id:        # An arbitrary state ID declaration.
  test_state:              # The custom state module name.
    - generate_vault_certificate      # The function in the custom state module.
    - common_name: ar.et             # Maps to the ``name`` parameter in the custom function.
    - file_path: /srv/salt/                  # Specify the required ``foo`` parameter.
    - vault_path: some/issue/some               # Override the default value for the ``bar`` parameter.
    - write: true
    - key_usage:
      - "critical Digital Signature"
      - "Key Encipherment"
      - "Key Agreement"