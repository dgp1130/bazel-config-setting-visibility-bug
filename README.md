# Bazel Visibility Bug

Bug report: https://github.com/bazelbuild/bazel/issues/19126

```
$ bazel build //:my_target
ERROR: /home/doug/Source/bazel_visibility/BUILD.bazel:3:8: in my_rule rule //:my_target: target '//config_setting:my_setting' is not visible from target '//build_defs:defs.bzl'. Check the visibility declaration of the former target if you think the dependency is legitimate
ERROR: /home/doug/Source/bazel_visibility/BUILD.bazel:3:8: Analysis of target '//:my_target' failed
ERROR: Analysis of target '//:my_target' failed; build aborted: 
INFO: Elapsed time: 0.064s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (2 packages loaded, 2 targets configured)
```

This bug appears to reproduce in the combination of:
1.  A target which depends on a `config_setting` from a different package
    through a `select` key.
1.  The target is an instance of a rule from a another package which does _not_
    have visibility into the `config_setting`.
1.  `--incompatible_visibility_private_attributes_at_definition`.
    * Set in the `.bazelrc`.

This appears to confuse Bazel, which treats the `config_setting` as an implicit
dependency of the rule which defined the target depending on it. This does not
make logical sense as the `config_setting` is not an implicit dependency and
should not need to be visible to the rule.
