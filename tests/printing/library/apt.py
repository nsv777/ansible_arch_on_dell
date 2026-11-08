#!/usr/bin/python
from ansible.module_utils.basic import AnsibleModule

module = AnsibleModule(
    argument_spec={"name": {"type": "list", "elements": "str"}, "state": {"type": "str"}},
    supports_check_mode=True,
)
module.exit_json(changed=False, ansible_facts={"printing_test_package": module.params})
