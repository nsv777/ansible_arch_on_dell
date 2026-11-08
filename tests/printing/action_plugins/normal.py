"""Record role module requests without changing a machine."""

from ansible.plugins.action import ActionBase


class ActionModule(ActionBase):
    def run(self, tmp=None, task_vars=None):
        result = super().run(tmp, task_vars)
        action = self._task.action
        allowed = {
            "ansible.builtin.apt",
            "ansible.builtin.getent",
            "ansible.builtin.setup",
            "ansible.builtin.systemd_service",
            "ansible.builtin.user",
        }
        if action not in allowed:
            return {"failed": True, "msg": f"Unexpected module: {action}"}

        args = self._templar.template(self._task.args)
        requests = task_vars.get("ansible_facts", {}).get("printing_test_requests", [])
        facts = {"printing_test_requests": requests + [{"action": action, "args": args}]}
        if action == "ansible.builtin.setup":
            facts["ansible_distribution"] = task_vars["printing_test_distribution"]
            facts["ansible_pkg_mgr"] = task_vars["printing_test_pkg_mgr"]
            facts["printing_test_mock"] = True
        if action == "ansible.builtin.getent":
            database = args["database"]
            entries = task_vars["printing_test_groups" if database == "group" else "printing_test_passwd"]
            if "key" in args:
                entries = {args["key"]: entries.get(args["key"])}
            facts[f"getent_{database}"] = entries
        result.update(changed=False, ansible_facts=facts)
        return result
