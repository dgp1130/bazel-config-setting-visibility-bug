def _my_rule_impl(ctx):
    pass

my_rule = rule(
    implementation = _my_rule_impl,
    attrs = {
        "value": attr.string(mandatory = True),
    },
)
